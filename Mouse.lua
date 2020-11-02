--=========
-- Include
--=========

--========
-- Module
--========

---@class Wc3InputMouse
local Mouse = {}

local period = 1/32

local new_x = {}
local new_y = {}
local x = {}
local y = {}

local function onMouseEvent()
    local pl = GetTriggerPlayer()

    new_x[pl] = BlzGetTriggerPlayerMouseX()
    new_y[pl] = BlzGetTriggerPlayerMouseY()
end

local function lerp(a, b, t)
	return a + (b - a) * t
end

local function onLoop()
    for pl, _ in pairs(new_x) do
        x[pl] = lerp(x[pl] or 0, new_x[pl], 1 / 3)
        y[pl] = lerp(y[pl] or 0, new_y[pl], 1 / 3)
    end
end

---@param pl player
---@return number
function Mouse.getX(pl)
    return x[pl or GetLocalPlayer()]
end

---@param pl player
---@return number
function Mouse.getY(pl)
    return y[pl or GetLocalPlayer()]
end

if IsGame() then
    local trigger = CreateTrigger()
    TriggerAddAction(trigger, onMouseEvent)

    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        local pl = Player(i)
        if GetPlayerController(pl) == MAP_CONTROL_USER and
           GetPlayerSlotState(pl) == PLAYER_SLOT_STATE_PLAYING then
            TriggerRegisterPlayerEvent(trigger, pl, EVENT_PLAYER_MOUSE_MOVE)
            TriggerRegisterPlayerEvent(trigger, pl, EVENT_PLAYER_MOUSE_UP)
            TriggerRegisterPlayerEvent(trigger, pl, EVENT_PLAYER_MOUSE_DOWN)
        end
    end

    local timer = CreateTimer()
    TimerStart(timer, period, true, onLoop)
end

return Mouse