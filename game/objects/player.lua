require 'game.objects.dynamic_entity'
anim8 = require 'lib.anim8'

Player = DynamicEntity:extend()

function Player:new(x, y, width, height, image, world, maxVelX, maxVelY, speed)
    Player.super.new(self, x, y, width, height, image, world, maxVelX, maxVelY, "ent_player")
    self.origX = x
    self.origY = y
    self.image = image

    self.world = world
    
    self.width = width 
    self.height = height

    self.speed = speed
    self.origMaxVel = maxVelX
    self.direction = 1
    self.going = 'right'

    ---------------------
    -- ANIMATIONS --
    ---------------------
    local g = anim8.newGrid(64, 64, self.image:getWidth(), self.image:getHeight())
    self.animationRight = anim8.newAnimation(g('1-9',10), {0, ['2-9']=0.08}):flipH()
    self.animationLeft = anim8.newAnimation(g('1-9', 10), {0, ['2-9']=0.08})
    self.animationDown = anim8.newAnimation(g('1-9',11), {0, ['2-9']=0.05})
    self.animationUp = anim8.newAnimation(g('1-9', 9), {0, ['2-9']=0.05})

    self.animationDeliverLeft = anim8.newAnimation(g('1-3',18, '2-1', 18), {0.1, 0.1, 0.5, 0.1, 3})
    self.animationDeliverRight = anim8.newAnimation(g('1-3',18, '2-1', 18), {0.1, 0.1, 0.5, 0.1, 3}):flipH()

    self.infected = false
end

function Player:update(dt)
    
    if self.xVel == 0 and self.yVel == 0 then
            self.animationRight:gotoFrame(1)
            self.animationLeft:gotoFrame(1)
            self.animationDown:gotoFrame(1)
            self.animationUp:gotoFrame(1)
    end

end


function Player:draw()

    if self.going == 'right' then
        self.animationRight:draw(self.image, self.x, self.y, 0, 0.9, 0.9, 17, 17) --- Offset Shear)
    elseif self.going == 'left' then
        self.animationLeft:draw(self.image, self.x, self.y, 0, 0.9, 0.9, 17, 17)
    elseif self.going == 'down' then
        self.animationDown:draw(self.image, self.x, self.y, 0, 0.9, 0.9, 17, 17) --- Offset Shear)
    elseif self.going == 'up' then
        self.animationUp:draw(self.image, self.x, self.y, 0, 0.9, 0.9, 17, 17)
    end

end


---------------------
-- PLAYER MOVEMENT --
---------------------
function Player:moveRight(dt)
  self.xVel = self.xVel + self.speed
  
  self.direction = 1
  self.going = 'right'

  self.animationRight:update(dt)

 	if self.xVel > self.maxVelX then self.xVel = self.maxVelX end
  if self.xVel < 0 then self.xVel = 0 end
     
  if self.direction == -1 then
    self.xVel = 0
  end
  
end

function Player:moveLeft(dt)
  self.xVel = self.xVel + self.speed
  self.direction = -1
  self.going = 'left'

  self.animationLeft:update(dt)
  
  if self.direction == 1 then
    self.xVel = 0
  end

  if self.xVel > self.maxVelX then self.xVel = self.maxVelX end
  if self.xVel < 0 then self.xVel = 0 end
  
end

function Player:moveDown(dt)
  self.yVel = self.yVel + self.speed
  self.direction = 1
  self.going = 'down'

  self.animationDown:update(dt)

  if self.direction == -1 then
    self.yVel = 0
  end

  if self.yVel > self.maxVelY then self.yVel = self.maxVelY end
  if self.yVel < 0 then self.yVel = 0 end
end

function Player:moveUp(dt)
  self.yVel = self.yVel + self.speed
  self.direction = -1
  self.going = 'up'

  self.animationUp:update(dt)

  if self.direction == 1 then
    self.yVel = 0
  end

  if self.yVel > self.maxVelY then self.yVel = self.maxVelY end
  if self.yVel < 0 then self.yVel = 0 end
  
end