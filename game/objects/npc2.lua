-- Class of second wave of npcs, which dont move but sneeze

require "game.objects.entity"
anim8 = require 'lib.anim8'

NPC2 = Entity:extend()

function NPC2:new(x, y, width, height, image, world, ent_name)
    NPC2.super.new(self, x, y, width, height, image, world, "ent_npc")
    self.x = x
    self.y = y    
    self.sprite = 'game/assets/images/sprites/sprite'..tostring(image)..'.png'

    self.image = love.graphics.newImage(self.sprite)
    self.virusImage = love.graphics.newImage('game/assets/images/sprites/cvirus.png')
    self.sneeze = love.audio.newSource("game/assets/sounds/sneeze2.ogg", "static")
    
    -- Random infected
    if love.math.random(1,5) == 1 then
        self.infected = true
      else
        self.infected = false
    end

    self.playerinfected = false
      
    self.viruses = {}
    self.timer = 0
    
    self.state = 'idle'
    
    local g = anim8.newGrid(64, 64, self.image:getWidth(), self.image:getHeight())
    self.animationIdle = anim8.newAnimation(g('1-7', 3), {1,0,0,0,0,0,1})
    self.animationSneeze = anim8.newAnimation(g('1-7',3), {0.2, 0.2, 0, 0.2, 0, 0, 0.2})
end


function NPC2:update(dt, entity, player)
    
    if self.infected == true then

        -- If player is near, sneeze and spread virus
        if player.x > self.x -256 and player.x < self.x +256 and 
        player.y > self.y -256 and player.y < self.y +256 then 
            self.timer = self.timer + dt
            self.state = 'sneeze'

            --Sneeze every 0.7 seconds
            if self.timer > 0.7 then 
                self.sneeze:play()
                virus = {}
                virus.x = self.x 
                virus.y = self.y
                virus.timer = 0
                table.insert(self.viruses, virus)
                self.timer = 0
            end

        else
            self.state = 'idle'
        end
    end

    for i,v in ipairs(self.viruses) do

        -- Virus spred and chase player
        v.timer = v.timer + dt
        if v.timer > 4 then 
            table.remove(self.viruses, i)
        end

        local direction_x = v.x - player.x
        local direction_y = v.y - player.y
        local distance = math.sqrt(direction_x * direction_x + direction_y * direction_y)

        if distance ~= 0 then
            v.x = v.x - direction_x / distance * 80 * dt
            v.y = v.y - direction_y / distance * 80 * dt
        end

        --If virus collide with player, player is infected so restart
        if v.x +18 >= player.x and v.x <= player.x + 29 and
            v.y +18 >= player.y and v.y <= player.y + 36 then
            self.playerinfected = true
        end
    end
    
    self.animationIdle:update(dt)
    self.animationSneeze:update(dt)
end

function NPC2:draw()
    
    if self.state == 'idle' then
        self.animationIdle:draw(self.image, self.x, self.y, 0, 0.9, 0.9, 17, 17)
    elseif self.state == 'sneeze' then
        self.animationSneeze:draw(self.image, self.x, self.y, 0, 0.9, 0.9, 17, 17)        
    end
    
    if self.infected == true then
        love.graphics.draw(self.virusImage, self.x +6, self.y -22)
    end

    for i,v in ipairs(self.viruses) do
		love.graphics.draw(self.virusImage, v.x, v.y)
    end
end
