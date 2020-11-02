--=========
-- Include
--=========

local lib_path = Lib.curPath()
local lib_dep = Lib.curDepencies()

---@type HandleLib
local HandleLib = lib_dep.Handle or error('')
local Trigger = HandleLib.Trigger or error('')
local Timer = HandleLib.Timer or error('')

--========
-- Module
--========

---@class InputMouse
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

if not IsCompiletime() then
    local trigger = Trigger.new()
    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        local pl = Player(i)
        if GetPlayerController(pl) == MAP_CONTROL_USER and
           GetPlayerSlotState(pl) == PLAYER_SLOT_STATE_PLAYING then
            trigger:addPlayerEvent(EVENT_PLAYER_MOUSE_MOVE, pl)
            trigger:addPlayerEvent(EVENT_PLAYER_MOUSE_UP, pl)
            trigger:addPlayerEvent(EVENT_PLAYER_MOUSE_DOWN, pl)
        end
    end
    trigger:addAction(onMouseEvent)

    local timer = Timer.new()
    timer:start(period, true, onLoop)
end

return Mouse