--=========
-- Include
--=========

local lib_path = Lib.curPath()
local lib_dep = Lib.curDepencies()

local Class = lib_dep.Class or error('')
---@type HandleLib
local HandleLib = lib_dep.Handle or error('')
local Trigger = HandleLib.Trigger or error('')
---@type UtilsLib
local UtilsLib = lib_dep.Utils or error('')
local ActionList = UtilsLib.ActionList or error('')
local isTypeErr = UtilsLib.isTypeErr or error('')
local Log = UtilsLib.Log or error('')

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
    if child then isTypeErr(child, InputDataSync, 'child') end

    local instance = child or Class.allocate(InputDataSync)
    private.newData(instance)

    return instance
end

--========
-- Public
--========

---@param msg string
function public:send(msg)
    BlzSendSyncData(private.data[self].id, msg)
end

---@alias InputDataSyncCallback fun(sync:InputDataSync, data:string, source:player)

---@param callback InputDataSyncCallback
---@return Action
function public:addAction(callback)
    local priv = private.data[self]
    return priv.actions:add(callback)
end

---@param action Action
---@return boolean
function public:removeAction(action)
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
        private.trigger:addPlayerSyncEvent(Player(i), priv.id, false)
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
    local player = GetTriggerPlayer()
    local data = BlzGetTriggerSyncData()

    private.data[self].actions:run(self, data, player)
end

if not IsCompiletime() then
    private.trigger = Trigger.new()
    private.trigger:addAction(private.runActions)
end

return static