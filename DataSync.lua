--=========
-- Include
--=========

local Class = LibManager.getDepency('LuaClass')
---@type Wc3Utils
local Utils = LibManager.getDepency('Wc3Utils')
local Action = Utils.Action or error('')
local ActionList = Utils.ActionList or error('')
local isTypeErr = Utils.isTypeErr or error('')
local Log = Utils.Log or error('')

--=======
-- Class
--=======

local InputDataSync = Class.new('InputDataSync')
---@class InputDataSync
local public = InputDataSync.public
---@class InputDataSyncClass
local static = InputDataSync.static
---@type InputDataSyncClass
local override = InputDataSync.override
local private = {}

--=========
-- Static
--=========

---@param child InputDataSync | nil
---@return InputDataSync
function override.new(child)
    isTypeErr(child, {InputDataSync, 'nil'}, 'child')

    local instance = child or Class.allocate(InputDataSync)
    private.newData(instance)

    return instance
end

--========
-- Public
--========

---@param msg string
function public:send(msg)
    isTypeErr(self, InputDataSync, 'self')
    isTypeErr(msg, 'string', 'msg')

    BlzSendSyncData(private.data[self].id, msg)
end

---@alias InputDataSyncCallback fun(sync:InputDataSync, data:string, source:player)

---@param callback InputDataSyncCallback
---@return Action
function public:addAction(callback)
    isTypeErr(self, InputDataSync, 'self')
    isTypeErr(callback, 'function', 'callback')
    local priv = private.data[self]

    return priv.actions:add(callback)
end

---@param action Action
---@return boolean
function public:removeAction(action)
    isTypeErr(self, InputDataSync, 'self')
    isTypeErr(action, Action, 'action')
    local priv = private.data[self]
    
    return priv.actions:remove(action)
end

--=========
-- Private
--=========

private.data = setmetatable({}, {__mode = 'k'})
private.id2obj = setmetatable({}, {__mode = 'v'})

---@param self InputDataSync
function private.newData(self)
    local priv = {
        id = private.getId(),
        actions = ActionList.new(self)
    }
    private.data[self] = priv
    private.id2obj[priv.id] = self

    -- Adds event to trigger
    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        BlzTriggerRegisterPlayerSyncEvent(private.trigger, Player(i), priv.id, false)
    end
end

local last_id = '!!!!'
---@return string
function private.getId()
    local p4 = string.byte(last_id, 1)
    local p3 = string.byte(last_id, 2)
    local p2 = string.byte(last_id, 3)
    local p1 = string.byte(last_id, 4)

    if p1 < 96 then
        p1 = p1 + 1
        while p1 >= 48 and p1 <= 57 do
            p1 = p1 + 1
        end
    elseif p2 < 96 then
        p1 = string.byte('!')
        p2 = p2 + 1
        while p2 >= 48 and p2 <= 57 do
            p2 = p2 + 1
        end
    elseif p3 < 96 then
        p1 = string.byte('!')
        p2 = string.byte('!')
        p3 = p3 + 1
        while p3 >= 48 and p3 <= 57 do
            p3 = p3 + 1
        end
    else
        Log:err('No valid ids left.', 2)
        return nil
    end

    last_id = string.char(p4)..string.char(p3)..string.char(p2)..string.char(p1)

    return last_id
end

function private.runActions()
    local self = private.id2obj[BlzGetTriggerSyncPrefix()]
    if not self then return end

    local player = GetTriggerPlayer()
    local data = BlzGetTriggerSyncData()

    private.data[self].actions:run(self, data, player)
end

if IsGame() then
    private.trigger = CreateTrigger()
    TriggerAddAction(private.trigger, private.runActions)
end

return static