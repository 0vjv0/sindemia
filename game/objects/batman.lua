-- Animated object. TO DO one class for all

require "game.objects.entity"
local anim8 = require 'lib.anim8'

Batman = Entity:extend()

function Batman:new(x, y, width, height, image, world, ent_name)
    Batman.super.new(self, x, y, width, height, image, world, "ent_batman")
    self.x = x
    self.y = y    
    self.image = image
 
    local g = anim8.newGrid(32, 32, self.image:getWidth(), self.image:getHeight())
    self.animation = anim8.newAnimation(g('25-26',20,'26-25',20,'25-30',20), 0.2)end

function Batman:update(dt, entity, player)
    self.animation:update(dt)
end

function Batman:draw()
    self.animation:draw(self.image, self.x, self.y)
end
