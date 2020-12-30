--[[ This is the game.

    Loads the map, the player, the endLevel, the npcs waves, and animated objects. 
    Handles physics and collisions.

    Infections occur when an infected npc collides with a non infected npc.
    If an infected npc cllides with player, the level restarts.
    
    Every npc infected is count.
    
    Screen displays population (number of npc + player + endLevel) and contagion rate.
    If rate exceeds 90%, the game is over.
    
    If player collides with endLevel and space key is press, the level is completed.
    
]]

local Gamestate = require 'lib.gamestate'

local sti = require 'lib.sti'
local bump = require 'lib.bump'
local SceneState = require 'states.scene'
local tween = require 'lib.tween'
local Timer = require "lib.timer"

require 'game.objects.entity'
require 'game.objects.dynamic_entity'
require 'game.objects.player'
require 'game.objects.end_level'

require 'game.objects.npc'
require 'game.objects.npc2'
require 'game.objects.npc3'

require 'game.objects.tree'--Animated objetcs. Needs refactoring
require 'game.objects.bird'
require 'game.objects.flag'
require 'game.objects.decor'
require 'game.objects.fan'
require 'game.objects.batman'
require 'game.objects.batman2'


local Level = {}

local rate_font = love.graphics.newFont('game/assets/fonts/virus43.ttf', 24)
local scene_font = love.graphics.newFont('game/assets/fonts/virus43.ttf', 23)

local game_music = love.audio.newSource("game/assets/music/TimePassingBy.ogg", "stream")
local ambiance = love.audio.newSource("game/assets/music/ambience.ogg", "stream")
local step = love.audio.newSource("game/assets/sounds/step2.ogg", "static")
local fail = love.audio.newSource("game/assets/sounds/fail.wav", "static")
local success = love.audio.newSource("game/assets/sounds/success.ogg", "static")

function Level:enter(_, level_index, counter, sprite)
    
    love.audio.stop()
    ambiance:play()

    self.current_level = level_index
    self.playerSprite = sprite --Chosed by player
    self.counter = counter --Number of npcs infected

    self.screenW = 768
    self.screenH = 432
    
    self.entities = {}
    self.player = {}
    self.npc = {}
    self.npc2 = {}
    self.npc3 = {}
    self.animated_objects = {}

   --Population (29 npc1 + 8 npc2 + 12 npc3 + 1 player + 1 endLevel)
    self.population = 50
    
    -- states
    self.restart = false
    self.contact = false
    self.finish = false
    self.over = false

    love.graphics.setFont(scene_font)
    love.graphics.setColor(0.9, 0.9, 0.8)

    --Level intro scene
    if self.current_level == 1 then  
        Gamestate.push(SceneState, "game/assets/scenes/level1.scene")
    elseif self.current_level == 2 then
        Gamestate.push(SceneState, "game/assets/scenes/level2.scene")
    elseif self.current_level == 3 then
        Gamestate.push(SceneState, "game/assets/scenes/level3.scene")
    end

    self.compassImage = love.graphics.newImage('game/assets/images/compass.png')
    self.rotation = 0 --radians of comppass rotation

    --Fade effects
    self.light = {alpha = 0}
    self.fadeIn = tween.new(1, self.light, {alpha = 1}, 'linear')
    self.fadeOut = tween.new(1, self.light, {alpha = 0}, 'linear')

    self:loadAssets()
    self:loadLevel()

end

function Level:resume()
   
    game_music:play() --Starts game music
    self.contact = false
    self.finish = false
    self.restart = false
end

function Level:loadAssets()
   
    --Pre-first sprite in folder for each npc
    self.npc1Sprite = 0 
    self.npc2Sprite = 16
    self.npc3Sprite = 6

    self.tilemap1 = love.graphics.newImage('game/assets/maps/tiles/Tilemap.png')
    self.tilemap2 = love.graphics.newImage('game/assets/maps/tiles/Tilemap2.png')
    self.tilemap3 = love.graphics.newImage('game/assets/maps/tiles/Tilemap3.png')
    
    if self.current_level == 1 then  
        self.endLevelsprite =  love.graphics.newImage('game/assets/images/endlevel/doctor.png')
    elseif self.current_level == 2 then
        self.endLevelsprite =  love.graphics.newImage('game/assets/images/endlevel/profesor.png')
    elseif self.current_level == 3 then
        self.endLevelsprite =  love.graphics.newImage('game/assets/images/endlevel/davis.png')
    end
    
    self.map = sti('game/assets/maps/random_map.lua', { "bump" }) -- ramdom map   

    self.mapW = 4096
    self.mapH = 4096

end

function Level:setupPhysics() -- For bump to manage collisions
    self.world = bump.newWorld(32)
end
 
function Level:loadLevel()

    self:setupPhysics()
      
	self.map:bump_init(self.world)
  
    --Loads objects from map
    for k, object in pairs(self.map.objects) do
        
        if object.name == 'spawn' then
            self.player = Player(object.x, object.y, 26, 39, self.playerSprite, self.world, 300, 300, 100)
            table.insert(self.entities, self.player)
            
        elseif object.name == 'endLevel' then
            self.endLevel = EndLevel(object.x, object.y, 26, 39, self.endLevelsprite, self.world, "ent_endLevel")
            table.insert(self.entities, self.endLevel)
            table.insert(self.animated_objects, self.endLevel)
        
        elseif object.name == "npc1" then
            self.npc1Sprite = self.npc1Sprite +1
            speed = love.math.random(280, 310)
            local npc = NPC(object.x, object.y, 26, 39, self.npc1Sprite, self.world, speed, speed, 100)
            
            if  npc.infected == true then
                self.counter = self.counter + 1
            end
            
            table.insert(self.entities, npc)
            table.insert(self.npc, npc)

        elseif object.name == "npc2" then
            if self.current_level > 1 then
                self.npc2Sprite = self.npc2Sprite +2
                local npc = NPC2(object.x, object.y, 26, 39, self.npc2Sprite, self.world)
                table.insert(self.entities, npc)
                table.insert(self.npc2, npc)
            end

        elseif object.name == "npc3" then
            if self.current_level > 2 then
                self.npc3Sprite = self.npc3Sprite +3
                speed = love.math.random(280, 310)
                local npc = NPC3(object.x, object.y, 26, 39, self.npc3Sprite, self.world, speed, speed, 100)
                table.insert(self.entities, npc)
                table.insert(self.npc3, npc) 
            end

        --Animated objects. Refactoring needed
        elseif object.name == 'tree' then
            local tree = Tree(object.x, object.y, 32, 32, self.tilemap1, self.world,
                "ent_tree")
            table.insert(self.entities, tree)
            table.insert(self.animated_objects, tree)

        elseif object.name == 'bird' then
            local bird = Bird(object.x, object.y, 32, 32, self.tilemap2, self.world,
                "ent_bird")
            table.insert(self.entities, bird)
            table.insert(self.animated_objects, bird)

        elseif object.name == 'flag' then
            local flag = Flag(object.x, object.y, 32, 32, self.tilemap1, self.world,
                "ent_flag")
            table.insert(self.entities, flag)
            table.insert(self.animated_objects, flag)

        elseif object.name == 'decor' then
            local decor = Decor(object.x, object.y, 32, 32, self.tilemap1, self.world,
                "ent_decor")
            table.insert(self.entities, decor)
            table.insert(self.animated_objects, decor)

        elseif object.name == 'fan' then
            local fan = Fan(object.x, object.y, 32, 32, self.tilemap3, self.world,
                "ent_fan")
            table.insert(self.entities, fan)
            table.insert(self.animated_objects, fan)

        elseif object.name == 'batman' then
            local batman = Batman(object.x, object.y, 32, 32, self.tilemap1, self.world,
                "ent_batman")
            table.insert(self.entities, batman)
            table.insert(self.animated_objects, batman)
            
        elseif object.name == 'batman2' then
            local batman2 = Batman2(object.x, object.y, 32, 32, self.tilemap1, self.world,
                "ent_batman2")
            table.insert(self.entities, batman2)
            table.insert(self.animated_objects, batman2)
        end
    end
    
    -- At least, 1 npc in first wave is infected
    if self.counter == 0 then
        self.counter = 1
        self.npc[1].infected = true
    end

    self.map:removeLayer('objects')
    self.map:removeLayer('collidable')

end

function Level:checkCols(entity, cols)
    
    for i,v in ipairs (cols) do
        self.other = cols[i].other  

        -- Social distance NPC contagion
        if entity.infected == true and self.other.infected == false then
            self.other.infected = true
            
            if self.other.name == 'ent_npc' then
                self.counter = self.counter + 1
        
            elseif self.other.name == 'ent_player' then 
                self.restart = true
                love.audio.stop()
                fail:play()
                Timer.after(4, function() Gamestate.pop() end) 
            end

        elseif self.other.infected == true and entity.infected == false then
            entity.infected = true
        
            if entity.name == "ent_npc" then
                self.counter = self.counter + 1                    
            elseif entity.name == 'ent_player' then
                self.restart = true
                love.audio.stop()
                Timer.after(4, function() Gamestate.pop() end) 
            end
        end
                
        -- Begin finish level; end with space key
        if entity.name == "ent_player" and self.other.name == "ent_endLevel" then
            self.contact = true
        end
    end
end

function Level:update(dt)

    self.fadeIn:update(dt)

    self.map:update(dt)
    self:manageKeyboard(dt)

    if self.restart == false and self.finish == false and self.over == false then
        
        for i=1,#self.entities do
            if self.entities[i]:is(DynamicEntity) then
                self.entities[i]:updatePhysics(dt)
            end
        end
        
        self.player.x, self.player.y, cols = self.world:move(
            self.player, self.player.x, self.player.y )
            self.player:update(dt)
            self:checkCols(self.player, cols)

        self:updateCompass(dt)

        for i=1,#self.npc do
            self.npc[i].x, self.npc[i].y, cols = self.world:move(
            self.npc[i], self.npc[i].x, self.npc[i].y)
            
            self.npc[i]:update(dt, cols, self)
            self:checkCols(self.npc[i], cols)
        end

        for i=1,#self.npc2 do            
            self.npc2[i]:update(dt, self, self.player)

            --Npc3 dont move, so no cols checcked. Restart if virus collide with player, in NPC3 file
            if self.npc2[i].playerinfected == true then 
                self.restart = true
                love.audio.stop()
                fail:play()
                Timer.after(4, function() Gamestate.pop() end) 
            end
        end

        for i=1,#self.npc3 do
            self.npc3[i].x, self.npc3[i].y, cols = self.world:move(
            self.npc3[i], self.npc3[i].x, self.npc3[i].y)

            self.npc3[i]:update(dt, cols, self, self.player.x, self.player.y)
            self:checkCols(self.npc3[i], cols)
        end

        for i=1,#self.animated_objects do
            self.animated_objects[i]:update(dt)
        end

        --Calculates contagion rate.
        self.rate = math.floor(self.counter * 100 / self.population)
        if self.rate > 90 then
            self.over = true
            fail:play()
            Timer.after(4, function() Gamestate.pop() end) 
        end
           
    else
        Timer.update(dt)
        self.fadeOut:update(dt)
    end
    
    if self.finish == true then

        self.player.animationDeliverLeft:update(dt)
        self.player.animationDeliverRight:update(dt)
        
        self.endLevel.animationDeliverLeft:update(dt)
        self.endLevel.animationDeliverRight:update(dt)
    end

    -- CAMERA
    self.camX = math.max(0, math.min(self.player.x - self.screenW / 2 + self.player.width / 2,
    math.min(self.mapW - self.screenW, self.player.x)))

    self.camY = math.max(0, math.min(self.player.y - self.screenH / 2 + self.player.height / 2,
        math.min(self.mapH - self.screenH, self.player.y)))
end


-- Input to player movement
function Level:manageKeyboard(dt)
    
    if self.restart == false and self.finish == false and self.over == false then

        if love.keyboard.isDown( "right" ) then 
            step:play()
            self.player:moveRight(dt)
            
        elseif love.keyboard.isDown("left") then
            step:play()
            self.player:moveLeft(dt)

        elseif love.keyboard.isDown("up") then
            step:play()
            self.player:moveUp(dt)

        elseif love.keyboard.isDown("down") then
            step:play()
            self.player:moveDown(dt)
        end

    end
end

function Level:updateCompass(dt)
    if self.player.x  + 50 <= self.endLevel.x and 
        self.player.y <= self.endLevel.y +50 and
            self.player.y +50 > self.endLevel.y
            then
        
        self.rotation = math.rad(90)
    
    elseif self.player.x + 50 <= self.endLevel.x and self.player.y > self.endLevel.y +50 then
        self.rotation = math.rad(45)

    elseif self.player.x + 50 <= self.endLevel.x and self.player.y +50 <= self.endLevel.y then
        self.rotation = math.rad(135)
    
    elseif self.player.x > self.endLevel.x +50 and 
    self.player.y <= self.endLevel.y +50 and
        self.player.y +50 > self.endLevel.y
        then
        self.rotation = math.rad(270)
    
    elseif self.player.x > self.endLevel.x +50 and self.player.y > self.endLevel.y +50 then
        self.rotation = math.rad(305)

    elseif self.player.x > self.endLevel.x +50 and self.player.y +50 <= self.endLevel.y then
        self.rotation = math.rad(225)

    elseif self.player.y > self.endLevel.y +50 and 
    self.player.x <= self.endLevel.x +50 and
        self.player.x + 50 > self.endLevel.x
            then
        self.rotation = math.rad(0)

    elseif self.player.y +50 < self.endLevel.y and 
    self.player.x <= self.endLevel.x +50 and
        self.player.x + 50 > self.endLevel.x
            then
        self.rotation = math.rad(180)
    end

end


function Level:draw()
    
    love.graphics.setColor( 0.9, .9, .8, self.light.alpha)
    love.graphics.translate(math.floor(-self.camX + 0.5), math.floor(-self.camY + 0.5))

    if self.finish == false then
                
        self.map:draw(math.floor(-self.camX + 0.5), math.floor(-self.camY + 0.5))

        for i=1,#self.entities do
            self.entities[i]:draw()
        end

        for i=1,#self.animated_objects do
            self.animated_objects[i]:draw()
        end

    else
        self.map:draw(math.floor(-self.camX + 0.5), math.floor(-self.camY + 0.5))
       
        if self.player.x >= self.endLevel.x + 13 then
            self.player.animationDeliverLeft:draw(self.playerSprite, self.player.x, self.player.y, 0, 0.9, 0.9, 17, 17)
            self.endLevel.animationDeliverRight:draw(self.endLevelsprite, self.player.x - 30, self.player.y, 0, 0.9, 0.9, 17, 17)
        
        elseif self.player.x < self.endLevel.x + 13 then
            self.player.animationDeliverRight:draw(self.playerSprite, self.player.x, self.player.y, 0, 0.9, 0.9, 17, 17)
            self.endLevel.animationDeliverLeft:draw(self.endLevelsprite, self.player.x + 30, self.player.y, 0, 0.9, 0.9, 17, 17)
        end
    end

    -- Rate and compass
    love.graphics.setFont(rate_font)
    love.graphics.setColor(0, 1, 0.1, self.light.alpha)

    love.graphics.print('Contagion rate: '..tostring(self.rate)..'%', 
        math.min(3370, math.max(40,self.player.x - 330)), math.max(10,self.player.y -190))

    love.graphics.draw(self.compassImage, 
        math.min(3400, math.max(70,self.player.x - 300)), math.max(60,self.player.y -140),
            self.rotation, 1, 1,30,30)

            -- Success / Fail messages
    love.graphics.setColor(0, 1, 0.1)

    if self.restart == true then
       love.graphics.print('You have been infected', self.player.x - 75, self.player.y-50) 

    elseif self.finish == true then
       love.graphics.print('Mission completed', self.player.x -50, self.player.y - 50)

    elseif self.over == true then
        
        love.graphics.setColor(0, 1, 0.1, 1)
        love.graphics.print("The contagion rate has exceeded 90%", self.player.x -140, self.player.y - 50)

        -- Contagion rate in red
        love.graphics.setColor(1, 0, 0.1, 1)
        love.graphics.print('Contagion rate: '..tostring(self.rate)..'%', 
            math.min(3370, math.max(40,self.player.x - 330)), math.max(10,self.player.y -190))
    
    end

    love.graphics.setColor( 0.9, .9, .8)
end

function Level:keyreleased(key, code)
    
    if key == 'q' then
        love.event.quit()

       --SPACE TO FINISH LEVEL
    elseif key == "space" and self.contact == true then
                
        self.current_level = self.current_level + 1
        love.audio.stop()
        success:play()
        self.finish = true
        Timer.after(4, function() Gamestate.pop() end)
    end
end

return Level