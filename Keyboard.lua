--=========
-- Include
--=========

---@type Wc3Utils
local Wc3Utils = LibManager.getDepency('Wc3Utils')
local ActionList = Wc3Utils.ActionList or error('')
local Log = Wc3Utils.Log or error('')

--========
-- Module
--========

---@class InputKeyboard
local Keyboard = {}

local key2data = {
    ['0'] = OSKEY_0,
    ['1'] = OSKEY_1,
    ['2'] = OSKEY_2,
    ['3'] = OSKEY_3,
    ['4'] = OSKEY_4,
    ['5'] = OSKEY_5,
    ['6'] = OSKEY_6,
    ['7'] = OSKEY_7,
    ['8'] = OSKEY_8,
    ['9'] = OSKEY_9,
    ['A'] = OSKEY_A,
    ['B'] = OSKEY_B,
    ['C'] = OSKEY_C,
    ['D'] = OSKEY_D,
    ['E'] = OSKEY_E,
    ['F'] = OSKEY_F,
    ['G'] = OSKEY_G,
    ['H'] = OSKEY_H,
    ['I'] = OSKEY_I,
    ['J'] = OSKEY_J,
    ['K'] = OSKEY_K,
    ['L'] = OSKEY_L,
    ['M'] = OSKEY_M,
    ['N'] = OSKEY_N,
    ['O'] = OSKEY_O,
    ['P'] = OSKEY_P,
    ['Q'] = OSKEY_Q,
    ['R'] = OSKEY_R,
    ['S'] = OSKEY_S,
    ['T'] = OSKEY_T,
    ['U'] = OSKEY_U,
    ['V'] = OSKEY_V,
    ['W'] = OSKEY_W,
    ['X'] = OSKEY_X,
    ['Y'] = OSKEY_Y,
    ['Z'] = OSKEY_Z,
}

local data2key = {}
for key, data in pairs(key2data) do
    data2key[data] = key
end

local actions = {}
local is_key_down = {}

---@alias InputKeyboardCallback fun(key:string, is_down:boolean, meta:number, pl:player)

---@param key string
---@param callback InputKeyboardCallback
---@return Action
function Keyboard.addAction(key, callback)
    local key_data = key2data[key]
    if not key_data then
        Log:err('Unavailable key.')
    end

    if not actions[key_data] then
        actions[key_data] = ActionList.new()
    end

    return actions[key_data]:add(callback)
end

---@param action Action
---@return boolean
function Keyboard.removeAction(action)
    for key_data, list in pairs(actions) do
        if list:remove(action) then
            return true
        end
    end
    return false
end

local function runActions()
    local pl = GetTriggerPlayer()
    local key_data = BlzGetTriggerPlayerKey()
    local is_down = BlzGetTriggerPlayerIsKeyDown()
    local meta = BlzGetTriggerPlayerMetaKey()

    if is_down == is_key_down[key_data] then
        return
    end

    if actions[key_data] then
        actions[key_data]:run(data2key[key_data], is_down, meta, pl)
    end
    is_key_down[key_data] = is_down
end

if IsGame() then
    local trigger = CreateTrigger()
    TriggerAddAction(trigger, runActions)

    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        local pl = Player(i)
        if GetPlayerController(pl) == MAP_CONTROL_USER and
           GetPlayerSlotState(pl) == PLAYER_SLOT_STATE_PLAYING then
            for key, key_data in pairs(key2data) do
                BlzTriggerRegisterPlayerKeyEvent(trigger, pl, key_data, 0, true)
                BlzTriggerRegisterPlayerKeyEvent(trigger, pl, key_data, 0, false)
            end
        end
    end
end

return Keyboard