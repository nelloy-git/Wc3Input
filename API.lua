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

---@type Wc3InputDataSync
Wc3Input.DataSync = require('DataSync') or error('')

---@type Wc3InputKeyboard
local Keyboard = require('Keyboard') or error('')
Wc3Input.addKeyboardAction = Keyboard.addAction or error('')
Wc3Input.removeKeyboardAction = Keyboard.removeAction or error('')

---@type Wc3InputMouse
local Mouse = require('Mouse') or error('')
Wc3Input.getMouseX = Mouse.getX or error('')
Wc3Input.getMouseY = Mouse.getY or error('')

---@type Wc3InputSelection
local Selection = require('Selection') or error('')
Wc3Input.addSelectionAction = Selection.addAction or error('')
Wc3Input.removeSelectionAction = Selection.removeAction or error('')
Wc3Input.lockSelection = Selection.lock or error('')

LibManager.endLib()

return Wc3Input