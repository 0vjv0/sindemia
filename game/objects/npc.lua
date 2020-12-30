-- Class of first and third wave of npcs

require 'game.objects.dynamic_entity'
local anim8 = require 'lib.anim8'

NPC = DynamicEntity:extend()

function NPC:new(x, y, width, height, image, world, maxVelX, maxVelY, speed)
    NPC.super.new(self, x, y, width, height, image, world, maxVelX, maxVelY, "ent_npc")
    self.origX = x
    self.origY = y
    self.speed = speed
    self.sprite = 'game/assets/images/sprites/sprite'..tostring(image)..'.png'
    self.image = love.graphics.newImage(self.sprite)

    self.world = world
        
    self.origMaxVel = maxVelX
    
    self.width = width 
    self.height = height

    self.virusImage = love.graphics.newImage('game/assets/images/sprites/cvirus.png')

    ---------------------
    -- ANIMATIONS --
    ---------------------
    local g = anim8.newGrid(64, 64, self.image:getWidth(), self.image:getHeight())
    self.animationRight = anim8.newAnimation(g('1-9',10), {0, ['2-9']=0.08}):flipH()
    self.animationLeft = anim8.newAnimation(g('1-9', 10), {0, ['2-9']=0.08})
    self.animationDown = anim8.newAnimation(g('1-9',11), {0, ['2-9']=0.05})
    self.animationUp = anim8.newAnimation(g('1-9', 9), {0, ['2-9']=0.05})

    self.direction = 1
    self.going = 'right'
    self.random_move = love.math.random(1, 4)

    if love.math.random(1,20) == 1 then
        self.infected = true
    else
        self.infected = false
    end
end

---------------------
-- NPC MOVEMENT --
---------------------
function NPC:moveRight(dt)
    self.xVel = self.xVel + self.speed
    
    self.direction = 1
    self.going = 'right'

    self.animationRight:update(dt)

    if self.xVel > self.maxVelX then self.xVel = self.maxVelX end
    if self.xVel < 0 then self.xVel = 0 end
     
    if self.direction == -1 then self.xVel = 0 end
end

function NPC:moveLeft(dt)
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

function NPC:moveDown(dt)
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

function NPC:moveUp(dt)
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

function NPC:update(dt, cols, entity)
        
    for i,v in ipairs (cols) do
        --Change direction if collision
        if cols[i] then
            self.random_move = love.math.random(1, 4)
        end
   end
  
  if self.random_move == 1 then
    self:moveRight(dt)
  elseif self.random_move == 2 then
    self:moveLeft(dt)
  elseif self.random_move == 3 then
    self:moveUp(dt)
  elseif self.random_move == 4 then
    self:moveDown(dt)
  end

end

function NPC:draw()
 
    if self.going == 'right' then
      self.animationRight:draw(self.image, self.x, self.y, 0, 0.9, 0.9, 17, 17)
    elseif self.going == 'left' then
      self.animationLeft:draw(self.image, self.x, self.y, 0, 0.9, 0.9, 17, 17)
    elseif self.going == 'down' then
      self.animationDown:draw(self.image, self.x, self.y, 0, 0.9, 0.9, 17, 17)
    elseif self.going == 'up' then
      self.animationUp:draw(self.image, self.x, self.y, 0, 0.9, 0.9, 17, 17)
    end
  
  if self.infected == true then
    love.graphics.draw(self.virusImage, self.x+6, self.y -22)
  end

end