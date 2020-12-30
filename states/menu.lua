local Gamestate = require 'lib.gamestate'
local credits = require 'states.credits'
local howto = require 'states.howto'
local game = require 'states.game'
local SceneState = require 'states.scene'
local tween = require 'lib.tween'

local Menu = {}
local select = 1

local light = {alpha = 1}
local fadeTween = tween.new(1, light, {alpha = 0}, 'linear')

local key_sound = love.audio.newSource("game/assets/sounds/key_sound.ogg", "static")
local menu_music = love.audio.newSource("game/assets/music/EmeraldTherapy.ogg", "stream")


function Menu:enter()
    
    selected = false
    Gamestate.push(SceneState, "game/assets/scenes/title.scene")

    font = love.graphics.newFont('game/assets/fonts/virus43.ttf', 50)
    title = love.graphics.newFont("game/assets/fonts/Coronaviral.otf", 90)
    instructions = love.graphics.newFont("game/assets/fonts/Coronaviral.otf", 20)

    love.graphics.setFont(title)

end

function Menu:resume()

    selected = false
    menu_music:play()

end

function Menu:update(dt)

    if selected == true then

        fadeTween:update(dt)

        if light.alpha == 0 then 

            if select == 1 then
                Gamestate.switch(game)
            elseif select == 2 then
                Gamestate.push(howto)
            elseif select == 3 then
                Gamestate.push(credits)
            else
                love.event.quit()
            end

            light.alpha = 1
        end
    end
end

function Menu:draw()

    love.graphics.setFont(title)

    if select == 1 then love.graphics.setColor( 0, 1, 0.1, light.alpha)
    else love.graphics.setColor( 1, 1, 1, light.alpha) end
    love.graphics.print("Play", 50, 50)

    if select == 2 then love.graphics.setColor( 0, 1, 0.1, light.alpha)
    else love.graphics.setColor( 1, 1, 1, light.alpha) end
    love.graphics.print("How to play", 50, 100)
    
    if select == 3 then love.graphics.setColor( 0, 1, 0.1, light.alpha)
    else love.graphics.setColor( 1, 1, 1, light.alpha) end
    love.graphics.print("Credits", 50, 150)
    
    if select == 4 then love.graphics.setColor( 0, 1, 0.1, light.alpha)
    else love.graphics.setColor( 1, 1, 1, light.alpha) end
       love.graphics.print("Quit", 50, 200)

    love.graphics.setColor( 0, 1, 0.1, light.alpha)
    love.graphics.setFont(instructions)
    love.graphics.print("Arrow keys to navigate", 50, 350)
    love.graphics.print("Press space to select", 50, 365)

end

function Menu:keyreleased(key)
    
    if key == 'down' then
        key_sound:play()

        select = select +1
        if select > 4 then
            select = 4
        end 

    elseif key == 'up' then
        key_sound:play()

        select = select -1
        if select < 1 then
            select = 1
        end 
    end
    
    if key == 'space' then
        selected = true
        key_sound:play()
    end
end

return Menu
