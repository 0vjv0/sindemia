--[[
    Sindemia is a small game developed
    by victorjvalbuena as a final project
    of the CS50 course during the global coronavirus pandemic.

    As a learning exercise, some objects, classes, animations
    and the random generation of the map have been developed
    in an 'artisan' way, from scratch, 
    and libraries and shared code have been used for other elements.

    The code is licensed under a MTI license,
    except for code developed by other people, such as libraries, who have their own rights.

    The rights of the images and the audio used belong to the persons indicated in the Credits.

    Enjoy the game!!

    Managua, December 29th, 2020.

]]

local Gamestate = require 'lib.gamestate'
local game = require 'states.game'
local menu = require 'states.menu'


function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    Gamestate.registerEvents()
    Gamestate.switch(menu)
end


function love.draw()
end
