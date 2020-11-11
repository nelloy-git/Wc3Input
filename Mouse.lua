--=========
-- Include
--=========

---@type Wc3Utils
local Wc3Utils = LibManager.getDepency('Wc3Utils')
local ActionList = Wc3Utils.ActionList or error('')
local isTypeErr = Wc3Utils.isTypeErr or error('')

---@type Wc3InputSettings
local Settings = require('Settings') or error('')

--========
-- Module
--========

---@class InputMouse
local Mouse = {}

local period = Settings.MousePosPeriod or error('')
local per_loop = Settings.MouseMovePerLoop or error('')

local new_x = {}
local new_y = {}
local x = {}
local y = {}

local actions = {
    UP = ActionList.new(),
    DOWN = ActionList.new(),
    MOVE = ActionList.new(),
}

local function updatePos()
    local pl = GetTriggerPlayer()
    new_x[pl] = BlzGetTriggerPlayerMouseX()
    new_y[pl] = BlzGetTriggerPlayerMouseY()
end

local callbacks = {
    UP = function()
        updatePos()
        actions.UP:run('UP', GetTriggerPlayer(), BlzGetTriggerPlayerMouseButton())
    end,
    DOWN = function()
        updatePos()
        actions.DOWN:run('DOWN', GetTriggerPlayer(), BlzGetTriggerPlayerMouseButton())
    end,
    MOVE = function()
        updatePos()
        actions.MOVE:run('MOVE', GetTriggerPlayer(), BlzGetTriggerPlayerMouseButton())
    end
}

local function lerp(a, b, t)
	return a + (b - a) * t
end

local function onLoop()
    for pl, _ in pairs(new_x) do
        x[pl] = lerp(x[pl] or 0, new_x[pl], per_loop)
        y[pl] = lerp(y[pl] or 0, new_y[pl], per_loop)
    end
end

---@param pl player | nil
---@return number
function Mouse.getX(pl)
    isTypeErr(pl, {'player', 'nil'}, 'pl')
    return x[pl or GetLocalPlayer()]
end

---@param pl player | nil
---@return number
function Mouse.getY(pl)
    isTypeErr(pl, {'player', 'nil'}, 'pl')
    return y[pl or GetLocalPlayer()]
end

---@alias InputMouseCallback fun(event:string, pl:player, btn:mousebuttontype | nil)

---@param event string | "'UP'" | "'DOWN'" | "'MOVE'"
---@param callback InputMouseCallback
---@return Action
function Mouse.addAction(event, callback)
    isTypeErr(event, 'string', 'event')
    isTypeErr(callback, 'function', 'callback')

    return actions[event]:add(callback)
end

---@param action Action
---@return boolean
function Mouse.removeAction(action)
    isTypeErr(action. Action, 'action')

    for event, list in pairs(actions) do
        if list:remove(action) then
            return true
        end
    end
    return false
end

if IsGame() then
    local triggers = {
        UP = CreateTrigger(),
        DOWN = CreateTrigger(),
        MOVE = CreateTrigger(),
    }

    for event, trigger in pairs(triggers) do
        TriggerAddAction(trigger, callbacks[event])
    end

    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        local pl = Player(i)

        if GetPlayerController(pl) == MAP_CONTROL_USER and
           GetPlayerSlotState(pl) == PLAYER_SLOT_STATE_PLAYING then

            TriggerRegisterPlayerEvent(triggers.UP, pl, EVENT_PLAYER_MOUSE_UP)
            TriggerRegisterPlayerEvent(triggers.DOWN, pl, EVENT_PLAYER_MOUSE_DOWN)
            TriggerRegisterPlayerEvent(triggers.MOVE, pl, EVENT_PLAYER_MOUSE_MOVE)
        end
    end

    local timer = CreateTimer()
    TimerStart(timer, period, true, onLoop)
end

return Mouse