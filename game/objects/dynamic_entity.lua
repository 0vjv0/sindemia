--Basic class for objects wich move (player, npcs1 and 3)

require "game.objects.entity"

DynamicEntity = Entity:extend()

local physicsMult = 65

function DynamicEntity:new(x, y, width, height, image, world, maxVelX, maxVelY, ent_name)
  DynamicEntity.super.new(self, x, y, width, height, image, world, ent_name)
  self.maxVelX = maxVelX
  self.maxVelY = maxVelY
  self.xVel = 0
  self.yVel = 0
  self.direction = 1
end


function DynamicEntity:updatePhysics(dt)
  
    self.xVel = self.xVel -50 * dt * physicsMult
    self.yVel = self.yVel -50 * dt * physicsMult

    if self.xVel > self.maxVelX then self.xVel = self.maxVelX end
    if self.xVel < 0 then self.xVel = 0 end
  
    if self.yVel > self.maxVelY then self.yVel = self.maxVelY end
    if self.yVel < 0 then self.yVel = 0 end

    self.x = self.x + self.direction*self.xVel*dt
    self.y = self.y + self.direction*self.yVel*dt

  --if self.x < 0 then self.x = 0 end
  --if self.y < 0 then self.y = 0 end
  
end