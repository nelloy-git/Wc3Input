LibManager.startLib('Wc3Input')

--===========
-- Depencies
--===========

LibManager.addDepency('LuaClass', 'https://github.com/nelloy-git/LuaClass.git')
LibManager.addDepency('Wc3Utils', 'https://github.com/nelloy-git/Wc3Utils.git')

--=====
-- API
--=====

---@class Wc3Input
local Wc3Input = {}

---@type InputDataSync
Wc3Input.DataSync = require('DataSync') or error('')
---@type InputKeyboard
Wc3Input.Keyboard = require('Keyboard') or error('')
---@type InputMouse
Wc3Input.Mouse = require('Mouse') or error('')
---@type InputSelection
Wc3Input.Selection = require('Selection') or error('')

LibManager.endLib()

return Wc3Input