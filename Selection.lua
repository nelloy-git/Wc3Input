--=========
-- Include
--=========

---@type HandleLib
local HandleLib = require(LibList.HandleLib) or error('')
local Trigger = HandleLib.Trigger
local Unit = HandleLib.Unit
---@type UtilsLib
local UtilsLib = require(LibList.UtilsLib) or error('')
local ActionList = UtilsLib.ActionList or error('')

--========
-- Module
--========

---@alias InputSelectionCallback fun(group:table<number, Unit>, pl:player)

---@class InputSelection
local Selection = {}

local lock = false
local group = {}
local actions = ActionList.new()

---@param group table<integer, Unit>
---@return table<integer, Unit>
local function clearDead(group)
    local new_group = {}
    for i = 1, #group do
        if group[i]:getHealth() > 0.5 then
            table.insert(new_group, group[i])
        end
    end
    return new_group
end

local function onSelection()
    local pl = GetTriggerPlayer()
    local u = Unit.getLinked(GetTriggerUnit())
    local gr = group[pl]

    if not u then return end

    local found = -1
    for i = 1, #gr do
        if gr[i] == u then
            found = i
            break
        end
    end

    if lock then
        if found < 0 and pl == GetLocalPlayer() then
            SelectUnit(u:getData(), false)
        end
    else
        if found < 0 then
            table.insert(gr, u)
            actions:run(gr, pl)
        end
    end
end

local function onDeselection()
    local pl = GetTriggerPlayer()
    local u = Unit.getLinked(GetTriggerUnit())
    local gr = group[pl]

    if not u then return end

    local found = -1
    for i = 1, #gr do
        if gr[i] == u then
            found = i
            break
        end
    end

    if lock then
        if found < 0 and pl == GetLocalPlayer() then
            SelectUnit(u:getData(), true)
        end
    else
        if found > 0 then
            table.remove(gr, found)
            actions:run(gr, pl)
        end
    end
end

---@param flag boolean
---@param pl player | nil
function Selection.lock(flag, pl)
    pl = pl or GetLocalPlayer()
    if pl ~= GetLocalPlayer() then
        return
    end

    lock = flag
    EnableSelect(not flag, true)
    EnableDragSelect(not flag, true)
    ClearSelection()

    local gr = group[pl]
    for i = 1, #gr do
        SelectUnit(gr[i]:getData(), true)
    end
end

---@param callback InputSelectionCallback
---@return Action
function Selection.addAction(callback)
    return actions:add(callback)
end

---@param action Action
---@return boolean
function Selection.removeAction(action)
    return actions:remove(action)
end

if not IsCompiletime() then
    local trigger_select = Trigger.new()
    local trigger_deselect = Trigger.new()
    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        local pl = Player(i)
        if GetPlayerController(pl) == MAP_CONTROL_USER and
           GetPlayerSlotState(pl) == PLAYER_SLOT_STATE_PLAYING then
            group[pl] = {}
            trigger_select:addPlayerUnitEvent(EVENT_PLAYER_UNIT_SELECTED, pl)
            trigger_deselect:addPlayerUnitEvent(EVENT_PLAYER_UNIT_DESELECTED, pl)
        end
    end
    trigger_select:addAction(onSelection)
    trigger_deselect:addAction(onDeselection)
end

return Selection