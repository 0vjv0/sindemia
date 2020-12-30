-- Subclass of third wave of npcs, wich moves and chase player if it is near

require 'game.objects.npc'
local anim8 = require 'lib.anim8'

NPC3 = NPC:extend()

function NPC3:new(x, y, width, height, image, world, maxVelX, maxVelY, speed)
    NPC3.super.new(self, x, y, width, height, image, world, maxVelX, maxVelY, "ent_npc3")
    self.origX = x
    self.origY = y
    self.speed = speed
    self.sprite = 'game/assets/images/sprites/sprite'..tostring(image)..'.png'
    self.image = love.graphics.newImage(self.sprite)

    self.world = world
        
    self.origMaxVel = maxVelX
    
    self.width = width 
    self.height = height

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

end

function NPC3:update(dt, cols, entity, playerX, playerY)
  
    --Change direction if collision
    if cols[i] then
        self.random_move = love.math.random(1, 4)
    end
  
    -- Chase player if it is near
    if playerX > self.x -256 and playerX < self.x +256 and 
      playerY > self.y -256 and playerY < self.y +256 then
        
        if self.x +29 < playerX  then
          self.random_move = 1
        elseif self.x > playerX +29 then
          self.random_move = 2
        else
          if self.y +36 < playerY then
             self.random_move = 4
          elseif self.y > playerY +36 then
            self.random_move = 3
          end
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