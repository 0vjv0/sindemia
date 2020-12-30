-- Class of endLevel

require "game.objects.entity"
local anim8 = require 'lib.anim8'

EndLevel = Entity:extend()

function EndLevel:new(x, y, width, height, image, world, ent_name)
    EndLevel.super.new(self, x, y, width, height, image, world, "ent_endLevel")
    self.x = x
    self.y = y    
    self.image = image
 
    local g = anim8.newGrid(64, 64, self.image:getWidth(), self.image:getHeight())
    self.animationIdle =  anim8.newAnimation(g('7-10',16), 2)
    self.animationDeliverLeft = anim8.newAnimation(g('1-3',18, '2-1', 18), {0.4, 0.1, 0.4, 0.1, 10})
    self.animationDeliverRight = anim8.newAnimation(g('1-3',18, '2-1', 18), {0.4, 0.1, 0.4, 0.1, 10}):flipH()
end

function EndLevel:update(dt, entity, player)
    self.animationIdle:update(dt)
end


function EndLevel:draw()
    self.animationIdle:draw(self.image, self.x, self.y, 0, 0.9, 0.9, 17, 17)
end