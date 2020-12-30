-- Animated object. TO DO one class for all

require "game.objects.entity"
local anim8 = require 'lib.anim8'

Tree = Entity:extend()

function Tree:new(x, y, width, height, image, world, ent_name)
    Tree.super.new(self, x, y, width, height, image, world, "tree")
    self.x = x
    self.y = y    
    self.image = image
 
    local g = anim8.newGrid(32, 32, self.image:getWidth(), self.image:getHeight())
    self.animation = anim8.newAnimation(g('1-15',17), 0.06)
end

function Tree:update(dt, entity, player)
    self.animation:update(dt)
end

function Tree:draw()
    self.animation:draw(self.image, self.x, self.y)
end
