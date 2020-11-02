---@class InputLib
local InputLibAPI = {}
Lib.start('Input', {
    Class = Lib.load(LibList.ClassLib) or error(''),
    Handle = Lib.load(LibList.HandleLib) or error(''),
    Utils = Lib.load(LibList.UtilsLib) or error(''),
})
local path = Lib.curPath()

--=====
-- API
--=====

---@type InputDataSync
InputLibAPI.DataSync = require(path..'DataSync') or error('')

---@type InputKeyboard
local Keyboard = require(path..'Keyboard') or error('')
InputLibAPI.addKeyboardAction = Keyboard.addAction or error('')
InputLibAPI.removeKeyboardAction = Keyboard.removeAction or error('')

---@type InputMouse
local Mouse = require(path..'Mouse') or error('')
InputLibAPI.getMouseX = Mouse.getX or error('')
InputLibAPI.getMouseY = Mouse.getY or error('')

---@type InputSelection
local Selection = require(path..'Selection') or error('')
InputLibAPI.addSelectionAction = Selection.addAction or error('')
InputLibAPI.removeSelectionAction = Selection.removeAction or error('')
InputLibAPI.lockSelection = Selection.lock or error('')

Lib.finish()

return InputLibAPI