--=========
-- Include
--=========

---@type Wc3Utils
local Wc3Utils = LibManager.getDepency('Wc3Utils') or error('')
local Color = Wc3Utils.Color or error('')

--=======
-- Module
--========

---@class Wc3InputSettings
local Settings = {}

Settings.MouseMovePerLoop = 1 / 3
Settings.MousePosPeriod = 1 / 32

return Settings