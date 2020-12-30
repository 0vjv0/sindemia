--[[
    Manages the scenes or transitions between levels or game states.
    Developed by Delisa
    https://git.drk.sc/kattrali/love-template
]]

local Gamestate = require 'lib.gamestate'
local SceneLoader = require 'game.scene_loader'

local state = {__animation = true}

function state:enter(_, scene_file_path)
  self.scene = SceneLoader(scene_file_path)
end

function state:draw()
  self.scene.draw()
end

function state:update(dt)
  self.scene.update(dt)
  if self.scene.done == true then
    Gamestate.pop()
  end
end

function state:keydown(key, code)
end

--function state:keyreleased(key, code)
  --if self.scene.awaiting_dialog_keyreleased and key == 'space' then
    --self.scene.dialogkeyreleased()
  --end
--end

return state