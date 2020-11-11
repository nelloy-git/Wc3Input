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
local Keyboard = require('Keyboard') or error('')
Wc3Input.addKeyboardAction = Keyboard.addAction or error('')
Wc3Input.removeKeyboardAction = Keyboard.removeAction or error('')

---@type InputMouse
Wc3Input.Mouse = require('Mouse') or error('')

---@type InputSelection
local Selection = require('Selection') or error('')
Wc3Input.addSelectionAction = Selection.addAction or error('')
Wc3Input.removeSelectionAction = Selection.removeAction or error('')
Wc3Input.lockSelection = Selection.lock or error('')

LibManager.endLib()

return Wc3Input