-- Animated object. TO DO one class for all

require "game.objects.entity"
local anim8 = require 'lib.anim8'

Flag = Entity:extend()

function Flag:new(x, y, width, height, image, world, ent_name)
    Flag.super.new(self, x, y, width, height, image, world, "ent_flag")
    self.x = x
    self.y = y    
    self.image = image
 
    local g = anim8.newGrid(32, 32, self.image:getWidth(), self.image:getHeight())
    self.animation = anim8.newAnimation(g('1-15',18), 0.06)
end

function Flag:update(dt, entity, player)
    self.animation:update(dt)
end

function Flag:draw()
    self.animation:draw(self.image, self.x, self.y)
end
