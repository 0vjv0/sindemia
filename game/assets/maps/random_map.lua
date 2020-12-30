--[[
    Loads map and game objects created in Tiled.

    Map is a 8 rows, 8 colum matrix of 16 tiles x 32 pixels.

    [0][0][0][0][0][0][0][0]
    [0][       ][       ][0]
    [0][   A   ][   B   ][0]
    [0][_______][_______][0]
    [0][       ][       ][0]
    [0][   C   ][   D   ][0]
    [0][_______][_______][0]
    [0][0][0][0][0][0][0][0]

    Firsts and lasts crows and columns, boders (0) loaded form World 3 layers.
    Iterior submaps are hoods (A,B,C,D) loaded from Hood 3 layers. 
    They are display randomly in 1,2,34, position.

    Roads layer are randomly display over World to connect border with hoods.

    Layers order

    1. World water
    2. World back
    3. Hoods back
    4. Hoods hood
    4. Hoods up
    5. Wordl up
    5. Roads

    Generates list of map objects (player, endLevel, nps, animated objects)
]]


-----------------------------------------------------------------------------------------
---INDEX. All layers in different files made with Tiled generator map
-----------------------------------------------------------------------------------------

--WORLD
local mundo_water = love.filesystem.load('game/assets/maps/mundo_water.lua')()
local mundo_back = love.filesystem.load('game/assets/maps/mundo_back.lua')()
local mundo_up = love.filesystem.load('game/assets/maps/mundo_up.lua')()

--ROADS
local road_North = love.filesystem.load('game/assets/maps/roads/road_North.lua')()
local road_West = love.filesystem.load('game/assets/maps/roads/road_West.lua')()
local road_South = love.filesystem.load('game/assets/maps/roads/road_South.lua')()
local road_East = love.filesystem.load('game/assets/maps/roads/road_East.lua')()

--HOODS
local A_Hood = love.filesystem.load('game/assets/maps/hoods/A_Hood.lua')()
local A_Back = love.filesystem.load('game/assets/maps/hoods/A_Back.lua')()
local A_Up = love.filesystem.load('game/assets/maps/hoods/A_Up.lua')()

local B_Hood = love.filesystem.load('game/assets/maps/hoods/B_Hood.lua')()
local B_Back = love.filesystem.load('game/assets/maps/hoods/B_Back.lua')()
local B_Up = love.filesystem.load('game/assets/maps/hoods/B_Up.lua')()

local C_Hood = love.filesystem.load('game/assets/maps/hoods/C_Hood.lua')()
local C_Back = love.filesystem.load('game/assets/maps/hoods/C_Back.lua')()
local C_Up = love.filesystem.load('game/assets/maps/hoods/C_Up.lua')()

local D_Hood = love.filesystem.load('game/assets/maps/hoods/D_Hood.lua')()
local D_Back = love.filesystem.load('game/assets/maps/hoods/D_Back.lua')()
local D_Up = love.filesystem.load('game/assets/maps/hoods/D_Up.lua')()-----------------------------------------------------------------------------------------


--RANDOM X Y FOR HOODS---------------------------------------------------------
math.randomseed(os.time())

local coord = {{x=1,y=1},{x=1,y=4},{x=4,y=1},{x=4,y=4}}
local hoodX = {}
local hoodY = {}

--Shuffle hoods position
for i=1, 4 do
    local rand = math.random(i, 4)
    coord[i], coord[rand] = coord[rand], coord[i]-- No repetition
end

--  Multiply by hoods' width and height
for i = 1, 4 do
  hoodX[i] = coord[i].x  * 32 * 16
  hoodY[i] = coord[i].y * 32 * 16
end
---------------------------------------------------------------------------------

-- RANDOM FOR ROADS
local roadXY = {1,2,3,4,5,6}
local roadW = {}
local roadE = {}
local roadS = {}
local roadN = {}

--Shuffle roads position
-- West Y
for i=1, 6 do
    local rand = math.random(i, 6)
    roadXY[i], roadXY[rand] = roadXY[rand], roadXY[i]
    roadW[i] = roadXY[i] * 32 *16
end

-- North X
for i=1, 6 do
    local rand = math.random(i, 6)
    roadXY[i], roadXY[rand] = roadXY[rand], roadXY[i]
    roadN[i] = roadXY[i] * 32 *16
end

-- South X
for i=1, 6 do
    local rand = math.random(i, 6)
    roadXY[i], roadXY[rand] = roadXY[rand], roadXY[i]
    roadS[i] = roadXY[i] * 32 *16
end

--East roads Y. One road less, never a road in upper, right corner
roadXY = {2,3,4,5,6}
for i=1, 5 do
    local rand = math.random(i, 5)
    roadXY[i], roadXY[rand] = roadXY[rand], roadXY[i]
    roadE[i] = roadXY[i] * 32 *16
end


-----------------------------------------------------------------------
-- Random spawn player, endLevel and NPCs, while player and endlevel are not inside a close space
local center = 240
local random_objects = {}
    random_objects = love.filesystem.load('game/assets/maps/random_objects.lua')()

-- Animated objects-------------------------------------------
local animated_objects = {}

-- Trees
-- coord. from tiled map
local treeX = {608,640,672,800,832,864,896,896,896,864,832,800,672,640,608,608,608,896,576,576,576,576,864}
local treeY = {640,640,640,640,640,640,640,832,896,896,896,896,896,896,896,832,704,704,640,832,896,704,704}
local trees = {}
--Trees to list
for i=1,#treeX do
    trees[i] =
    {
        id = 300 + i,
        name = "tree",
        type = "",
        shape = "rectangle",
        x = hoodX[2] + treeX[i],
        y = hoodY[2] + treeY[i] -32,
        width = 32,
        height = 32,
        rotation = 0,
        visible = true,
        properties = {}
    }
    table.insert(animated_objects, trees[i])
end

-- Birds
-- coord.
local birdX = {224, 384, 1120, 1440}
local birdY = {960, 960, 1152, 1184}
local birds = {}
-- Birds to list
for i=1,#birdX do
    birds[i] =
    {
        id = 400 + i,
        name = "bird",
        type = "",
        shape = "rectangle",
        x =  hoodX[2] + birdX[i],
        y =  hoodY[2] + birdY[i],
        width = 32,
        height = 32,
        rotation = 0,
        visible = true,
        properties = {}
    }
    table.insert(animated_objects, birds[i])
end

--AC fans
--coord.
local fanX = {0608,0608,0352,0160,0352,0064,0928,1184,0992,0896,1024,1408,1440,1472,1440,1344,1216}
local fanY = {1088,1248,1408,1248,0928,1440,1440,1440,1056,0672,0672,0960,1216,0704,0704,0416,0192}
local fans = {}
-- fans to list
for i=1,#fanX do
    fans[i] =
    {
        id = 700 + i,
        name = "fan",
        type = "",
        shape = "rectangle",
        x =  hoodX[3] + fanX[i],
        y =  hoodY[3] + fanY[i] -32,
        width = 32,
        height = 32,
        rotation = 0,
        visible = true,
        properties = {}
    }
    table.insert(animated_objects, fans[i])
end

--Flags
--coord.
local flagX = {320,224,384,480,480,384,320,224}
local flagY = {672,672,672,672,704,704,704,704}
local flags = {}
-- Flags to list
for i=1,#flagX do
    flags[i] =
    {
        id = 500 + i,
        name = "flag",
        type = "",
        shape = "rectangle",
        x =  hoodX[4] + flagX[i],
        y =  hoodY[4] + flagY[i],
        width = 32,
        height = 32,
        rotation = 0,
        visible = true,
        properties = {}
    }
    table.insert(animated_objects, flags[i])
end

--Decor lights
--coord.
local decorX = {000,032,064,416,256,096,128,160,192,224,416,480,704,672,608,640,544,576,512,448,384,352,320,288,}
local decorY = 640
local decors = {}
-- decors to list
for i=1,#decorX do
    decors[i] =
    {
        id = 600 + i,
        name = "decor",
        type = "",
        shape = "rectangle",
        x =  hoodX[4] + decorX[i],
        y =  hoodY[4] + decorY,
        width = 32,
        height = 32,
        rotation = 0,
        visible = true,
        properties = {}
    }
    table.insert(animated_objects, decors[i])
end

-- Batman (kid playing baseball body)
for i=1,1 do
    batman =
        {
            id = 650 + i,
            name = "batman",
            type = "",
            shape = "rectangle",
            x =  hoodX[3] + 128,
            y =  hoodY[3] + 512,
            width = 32,
            height = 32,
            rotation = 0,
            visible = true,
            properties = {}
        }

    table.insert(animated_objects, batman)
end

-- Batman2 (kid playing baseball legs)
for i=1,1 do
    batman2 =
        {
            id = 651 + i,
            name = "batman2",
            type = "",
            shape = "rectangle",
            x =  hoodX[3] + 128,
            y =  hoodY[3] + 544,
            width = 32,
            height = 32,
            rotation = 0,
            visible = true,
            properties = {}
        }

    table.insert(animated_objects, batman2)
end

MapData = {
  version = "1.4",
  luaversion = "5.1",
  tiledversion = "1.4.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 32,
  height = 32,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 30,
  nextobjectid = 163,
  properties = {},
  tilesets =
  {
    {
        name = "Tilemap",
        firstgid = 1,
        filename = "/tiles/Tilemap.tsx",
        tilewidth = 32,
        tileheight = 32,
        spacing = 0,
        margin = 0,
        columns = 31,
        image = "/tiles/Tilemap.png",
        imagewidth = 992,
        imageheight = 672,
        objectalignment = "unspecified",
        tileoffset = {
          x = 0,
          y = 0
        },
        grid = {
          orientation = "orthogonal",
          width = 32,
          height = 32
        },
        properties = {},
        terrains = {},
        tilecount = 651,
        tiles = {}
      },
      {
        name = "Tilemap2",
        firstgid = 652,
        filename = "/tiles/Tilemap2.tsx",
        tilewidth = 32,
        tileheight = 32,
        spacing = 0,
        margin = 0,
        columns = 33,
        image = "/tiles/Tilemap2.png",
        imagewidth = 1056,
        imageheight = 960,
        objectalignment = "unspecified",
        tileoffset = {
          x = 0,
          y = 0
        },
        grid = {
          orientation = "orthogonal",
          width = 32,
          height = 32
        },
        properties = {},
        terrains = {},
        tilecount = 990,
        tiles = {}
      },
      {
        name = "Tilemap3",
        firstgid = 1642,
        filename = "/tiles/Tilemap3.tsx",
        tilewidth = 32,
        tileheight = 32,
        spacing = 0,
        margin = 0,
        columns = 34,
        image = "/tiles/Tilemap3.png",
        imagewidth = 1088,
        imageheight = 512,
        objectalignment = "unspecified",
        tileoffset = {
          x = 0,
          y = 0
        },
        grid = {
          orientation = "orthogonal",
          width = 32,
          height = 32
        },
        properties = {},
        terrains = {},
        tilecount = 544,
        tiles = {}
      }
    },
  layers = {

        -- World layer
        {--WATER
            type = "tilelayer",
            x = 0,
            y = 0,
            width = 128,
            height = 128,
            id = 0,
            name = "world",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = mundo_water
        },

        {--A-back
            type = "tilelayer",
            x = hoodX[1],
            y = hoodY[1],
            width = 48,
            height = 48,
            id = 2,
            name = "A-back",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = A_Back
        },
        {--A
            type = "tilelayer",
            x = hoodX[1],
            y = hoodY[1],
            width = 48,
            height = 48,
            id = 3,
            name = "AHood",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = A_Hood
        },
        {--A-up
            type = "tilelayer",
            x = hoodX[1],
            y = hoodY[1],
            width = 48,
            height = 48,
            id = 4,
            name = "A-up",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = A_Up
        },

        {--B-back
            type = "tilelayer",
            x = hoodX[2],
            y = hoodY[2],
            width = 48,
            height = 48,
            id = 0,
            name = "B-back",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = B_Back
        },
        {--B hood
            type = "tilelayer",
            x = hoodX[2],
            y = hoodY[2],
            width = 48,
            height = 48,
            id = 0,
            name = "BHood",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = B_Hood
        },
        {--B-up
            type = "tilelayer",
            x = hoodX[2],
            y = hoodY[2],
            width = 48,
            height = 48,
            id = 0,
            name = "B-up",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = B_Up
        },


        {--C-Back
            type = "tilelayer",
            x = hoodX[3],
            y = hoodY[3],
            width = 48,
            height = 48,
            id = 0,
            name = "CHood",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = C_Back
        },
        {--C-Hood
            type = "tilelayer",
            x = hoodX[3],
            y = hoodY[3],
            width = 48,
            height = 48,
            id = 0,
            name = "CHood",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = C_Hood
        },
        {--C-Up
            type = "tilelayer",
            x = hoodX[3],
            y = hoodY[3],
            width = 48,
            height = 48,
            id = 0,
            name = "C_Up",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = C_Up
        },

        {--D-Back
            type = "tilelayer",
            x = hoodX[4],
            y = hoodY[4],
            width = 48,
            height = 48,
            id = 0,
            name = "D",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = D_Back
        },
        {--D-Hood
            type = "tilelayer",
            x = hoodX[4],
            y = hoodY[4],
            width = 48,
            height = 48,
            id = 0,
            name = "DHood",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = D_Hood
        },
        {--D-Up
            type = "tilelayer",
            x = hoodX[4],
            y = hoodY[4],
            width = 48,
            height = 48,
            id = 0,
            name = "DHood",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = D_Up
        },

        -- This are the world layers
        {--BACK
            type = "tilelayer",
            x = 0,
            y = 0,
            width = 128,
            height = 128,
            id = 1,
            name = "world",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = mundo_back
        },
        {--MUNDO-UP
            type = "tilelayer",
            x = 0,
            y = 0,
            width = 128,
            height = 128,
            id = 0,
            name = "Up-world",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = mundo_up
        },

        {--Roads East
            type = "tilelayer",
            x = 7*32*16,
            y = roadE[1],
            width = 16,
            height = 16,
            id = 0,
            name = "Roads East",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = road_East
        },
        {--Roads East
            type = "tilelayer",
            x = 7*32*16,
            y = roadE[2],
            width = 16,
            height = 16,
            id = 0,
            name = "Roads East",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = road_East
        },
        {--Roads East
            type = "tilelayer",
            x = 7*32*16,
            y = roadE[3],
            width = 16,
            height = 16,
            id = 0,
            name = "Roads East",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = road_East
        },
        {--Roads East
            type = "tilelayer",
            x = 7*32*16,
            y = roadE[4],
            width = 16,
            height = 16,
            id = 0,
            name = "Up-world",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = road_East
        },

        {--Roads West
            type = "tilelayer",
            x = 0,
            y = roadW[4],
            width = 16,
            height = 16,
            id = 0,
            name = "Roads West",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = road_West
        },
        {--Roads West
            type = "tilelayer",
            x = 0,
            y = roadW[5],
            width = 16,
            height = 16,
            id = 0,
            name = "Roads West",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = road_West
        },
        {--Roads West
            type = "tilelayer",
            x = 0,
            y = roadW[6],
            width = 16,
            height = 16,
            id = 0,
            name = "Roads West",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = road_West
        }, 

        {--Roads South
            type = "tilelayer",
            x = roadS[1],
            y = 7*32*16-32,
            width = 16,
            height = 17,
            id = 0,
            name = "Roads South",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = road_South
        },
        {--Roads South
            type = "tilelayer",
            x = roadS[2],
            y = 7*32*16-32,
            width = 16,
            height = 17,
            id = 0,
            name = "Roads South",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = road_South
        },
        {--Roads South
            type = "tilelayer",
            x = roadS[3],
            y = 7*32*16-32,
            width = 16,
            height = 17,
            id = 0,
            name = "Roads South",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = road_South
        },
        {--Roads South
            type = "tilelayer",
            x = roadS[4],
            y = 7*32*16-32,
            width = 16,
            height = 16,
            id = 0,
            name = "Roads South",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = road_South
        },

        {--Roads North
            type = "tilelayer",
            x = roadN[1],
            y = 0,
            width = 16,
            height = 16,
            id = 0,
            name = "Roads North",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = road_North
        },
        {--Roads North
            type = "tilelayer",
            x = roadN[2],
            y = 0,
            width = 16,
            height = 16,
            id = 0,
            name = "Roads North",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = road_North
        },
        {--Roads North
            type = "tilelayer",
            x = roadN[3],
            y = 0,
            width = 16,
            height = 16,
            id = 0,
            name = "Roads North",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            encoding = "lua",
            data = road_North
        },

-- OBJECTS
        { 
            type = "objectgroup",
            draworder = "topdown",
            id = 167,
            name = "objects",
            visible = false,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            objects = random_objects
        },
        { 
            type = "objectgroup",
            draworder = "topdown",
            id = 10000,
            name = "animated_objects",
            visible = false,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            objects = animated_objects
        },
        { -- COllIDABLES
            type = "objectgroup",
            draworder = "topdown",
            id = 3,
            name = "collidable",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {
            ["collidable"] = true
        },
            objects = {
                {-- North limit
                    id = 163,
                    name = "North border",
                    type = "",
                    shape = "rectangle",
                    x = 0,
                    y = 0,
                    width = 4096,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- South limit
                    id = 164,
                    name = "South border",
                    type = "",
                    shape = "rectangle",
                    x = 0,
                    y = 3900,
                    width = 4096,
                    height = 192,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--West limit
                    id = 165,
                    name = "West border",
                    type = "",
                    shape = "rectangle",
                    x = 0,
                    y = 192,
                    width = 190,
                    height = 3712,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--East limit
                    id = 166,
                    name = "East border",
                    type = "",
                    shape = "rectangle",
                    x = 3904,
                    y = 192,
                    width = 200,
                    height = 3712,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },

                {--East vegetation
                    id = 166,
                    name = "East vegetation",
                    type = "",
                    shape = "rectangle",
                    x = 3648,
                    y =  576,
                    width = 32,
                    height = 96,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--East vegetation
                    id = 166,
                    name = "East vegetation",
                    type = "",
                    shape = "rectangle",
                    x = 3680,
                    y =  576,
                    width = 32,
                    height = 320,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--East vegetation
                    id = 166,
                    name = "East vegetation",
                    type = "",
                    shape = "rectangle",
                    x = 3712,
                    y =  864,
                    width = 32,
                    height = 96,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--East vegetation
                    id = 166,
                    name = "East vegetation",
                    type = "",
                    shape = "rectangle",
                    x = 3776,
                    y =  832,
                    width = 32,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--East vegetation
                    id = 166,
                    name = "East vegetation",
                    type = "",
                    shape = "rectangle",
                    x = 3744 ,
                    y =  576,
                    width = 64,
                    height = 96,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--East vegetation
                    id = 166,
                    name = "East vegetation",
                    type = "",
                    shape = "rectangle",
                    x = 3712,
                    y =  1088,
                    width = 32,
                    height = 10,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--East vegetation
                    id = 166,
                    name = "East vegetation",
                    type = "",
                    shape = "rectangle",
                    x = 3680,
                    y =  1120,
                    width = 32,
                    height = 96,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--East vegetation
                    id = 166,
                    name = "East vegetation",
                    type = "",
                    shape = "rectangle",
                    x = 3648,
                    y =  3616,
                    width = 128,
                    height = 96,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                
                {--NO Road west
                    id = 166,
                    name = "Road west",
                    type = "",
                    shape = "rectangle",
                    x = 0 +320,
                    y =  roadW[1],
                    width = 160,
                    height = 512,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--NO Road west
                    id = 166,
                    name = "Road west",
                    type = "",
                    shape = "rectangle",
                    x = 0 +320,
                    y =  roadW[2],
                    width = 160,
                    height = 512,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--NO Road west
                    id = 166,
                    name = "Road west",
                    type = "",
                    shape = "rectangle",
                    x = 0 +320,
                    y =  roadW[3],
                    width = 160,
                    height = 512,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road west
                    id = 166,
                    name = "Road west",
                    type = "",
                    shape = "rectangle",
                    x = 0 +320,
                    y =  roadW[4],
                    width = 160,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road west
                    id = 166,
                    name = "Road west",
                    type = "",
                    shape = "rectangle",
                    x = 0 +320,
                    y =  roadW[4]+320,
                    width = 160,
                    height = 192,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road west
                    id = 166,
                    name = "Road west",
                    type = "",
                    shape = "rectangle",
                    x = 0 +320,
                    y =  roadW[5],
                    width = 160,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road west
                    id = 166,
                    name = "Road west",
                    type = "",
                    shape = "rectangle",
                    x = 0 +320,
                    y =  roadW[5]+320,
                    width = 160,
                    height = 192,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road west
                    id = 166,
                    name = "Road west",
                    type = "",
                    shape = "rectangle",
                    x = 0 +320,
                    y =  roadW[6],
                    width = 160,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road west
                    id = 166,
                    name = "Road west",
                    type = "",
                    shape = "rectangle",
                    x = 0 +320,
                    y =  roadW[6]+320,
                    width = 160,
                    height = 192,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },

                {--Road South
                    id = 166,
                    name = "Road South",
                    type = "",
                    shape = "rectangle",
                    x = roadS[1],
                    y =  (7*32*16)+32,
                    width = 224,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road South
                    id = 166,
                    name = "Road South",
                    type = "",
                    shape = "rectangle",
                    x = roadS[1] +288,
                    y =  (7*32*16)+32,
                    width = 224,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road South
                    id = 166,
                    name = "Road South",
                    type = "",
                    shape = "rectangle",
                    x = roadS[2],
                    y =  (7*32*16)+32,
                    width = 224,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road South
                    id = 166,
                    name = "Road South",
                    type = "",
                    shape = "rectangle",
                    x = roadS[2] +288,
                    y =  (7*32*16)+32,
                    width = 224,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road South
                    id = 166,
                    name = "Road South",
                    type = "",
                    shape = "rectangle",
                    x = roadS[3],
                    y =  (7*32*16)+32,
                    width = 224,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road South
                    id = 166,
                    name = "Road South",
                    type = "",
                    shape = "rectangle",
                    x = roadS[3] +288,
                    y =  (7*32*16)+32,
                    width = 224,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road South
                    id = 166,
                    name = "Road South",
                    type = "",
                    shape = "rectangle",
                    x = roadS[4],
                    y =  (7*32*16)+32,
                    width = 224,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road South
                    id = 166,
                    name = "Road South",
                    type = "",
                    shape = "rectangle",
                    x = roadS[4] +288,
                    y =  (7*32*16)+32,
                    width = 224,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--NO Road South
                    id = 166,
                    name = "Road South",
                    type = "",
                    shape = "rectangle",
                    x = roadS[5],
                    y =  (7*32*16)+32,
                    width = 512,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--NO Road South
                    id = 166,
                    name = "Road South",
                    type = "",
                    shape = "rectangle",
                    x = roadS[6],
                    y =  (7*32*16)+32,
                    width = 512,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Market top
                    id = 166,
                    name = "Market top",
                    type = "",
                    shape = "rectangle",
                    x = 320,
                    y =  448,
                    width = 160,
                    height = 64,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Market bott
                    id = 166,
                    name = "Market bott",
                    type = "",
                    shape = "rectangle",
                    x = 320,
                    y =  3552,
                    width = 160,
                    height = 192,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },

                {--Road North
                    id = 166,
                    name = "Road North",
                    type = "",
                    shape = "rectangle",
                    x = roadN[1],
                    y =  352,
                    width = 224,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road North
                    id = 166,
                    name = "Road North",
                    type = "",
                    shape = "rectangle",
                    x = roadN[1] +288,
                    y =  352,
                    width = 224,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road North
                    id = 166,
                    name = "Road North",
                    type = "",
                    shape = "rectangle",
                    x = roadN[2],
                    y =  352,
                    width = 224,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road North
                    id = 166,
                    name = "Road North",
                    type = "",
                    shape = "rectangle",
                    x = roadN[2] +288,
                    y =  352,
                    width = 224,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road North
                    id = 166,
                    name = "Road North",
                    type = "",
                    shape = "rectangle",
                    x = roadN[3],
                    y =  352,
                    width = 224,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Road North
                    id = 166,
                    name = "Road North",
                    type = "",
                    shape = "rectangle",
                    x = roadN[3] +288,
                    y =  352,
                    width = 224,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--No Road North
                    id = 166,
                    name = "Road North",
                    type = "",
                    shape = "rectangle",
                    x = roadN[4],
                    y =  352,
                    width = 512,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--No Road North
                    id = 166,
                    name = "Road North",
                    type = "",
                    shape = "rectangle",
                    x = roadN[5],
                    y =  352,
                    width = 512,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },      
                {--No Road North
                    id = 166,
                    name = "Road North",
                    type = "",
                    shape = "rectangle",
                    x = roadN[6],
                    y =  352,
                    width = 512,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--Top right corner
                    id = 166,
                    name = "Road North",
                    type = "",
                    shape = "rectangle",
                    x = 3584,
                    y =  352,
                    width = 224,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },

                {-- A1
                    id = 163,
                    name = "A1",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1],
                    y = hoodY[1],
                    width = 224,
                    height = 672,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A2

                    id = 163,
                    name = "AX",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1]+32,
                    y = hoodY[1]+832,
                    width = 672,
                    height = 352,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A3

                    id = 163,
                    name = "A3",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1]+320,
                    y = hoodY[1]+1184,
                    width = 384,
                    height = 256,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A4

                    id = 163,
                    name = "A4",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1],
                    y = hoodY[1]+1312,
                    width = 224,
                    height = 96,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A5

                    id = 163,
                    name = "AX",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1] +832,
                    y = hoodY[1]+832,
                    width = 96,
                    height = 352,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A6

                    id = 163,
                    name = "A6",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1] +1408,
                    y = hoodY[1] +320,
                    width = 96,
                    height = 768,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A7

                    id = 163,
                    name = "AX",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1] +1024,
                    y = hoodY[1] +832,
                    width = 288,
                    height = 96,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A8

                    id = 163,
                    name = "AX",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1] +928,
                    y = hoodY[1] +1088,
                    width = 576,
                    height = 96,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A9

                    id = 163,
                    name = "A9",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1] +1344,
                    y = hoodY[1],
                    width = 160,
                    height = 192,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A10

                    id = 163,
                    name = "A10",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1] +480,
                    y = hoodY[1] +512,
                    width = 96,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A10B
                    id = 163,
                    name = "A10B",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1] +512,
                    y = hoodY[1] +480,
                    width = 32,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A11
                    id = 163,
                    name = "A11",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1] +320,
                    y = hoodY[1],
                    width = 96,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A12
                    id = 163,
                    name = "A12",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1] +544,
                    y = hoodY[1],
                    width = 704,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A13
                    id = 163,
                    name = "A13",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1] +832,
                    y = hoodY[1] +288,
                    width = 384,
                    height = 384,
                    rotation = 0,
                    visible = true,
                    properties = {}
                }, 
                {-- A14
                    id = 163,
                    name = "A14",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1],
                    y = hoodY[1] +1408,
                    width = 32,
                    height = 16,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A15
                    id = 163,
                    name = "A15",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1] +32,
                    y = hoodY[1] +1408,
                    width = 32,
                    height = 16,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A16
                    id = 163,
                    name = "A16",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1] +96,
                    y = hoodY[1] +1424,
                    width = 32,
                    height = 16,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- A17
                    id = 163,
                    name = "A17",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[1] +160,
                    y = hoodY[1] +1424,
                    width = 32,
                    height = 16,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                
                {-- B1
                    id = 38,
                    name = "B1",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] + 32,
                    y = hoodY[2],
                    width = 160,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B2
                    id = 38,
                    name = "B2",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2],
                    y = hoodY[2]+ 1120,
                    width = 736,
                    height = 96,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B3
                    id = 38,
                    name = "B3",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +320,
                    y = hoodY[2],
                    width = 896,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B4
                    id = 38,
                    name = "B4",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +288,
                    y = hoodY[2] +320,
                    width = 384,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B5
                    id = 38,
                    name = "B5",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2],
                    y = hoodY[2] +1376,
                    width = 736,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B6
                    id = 38,
                    name = "B6",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +800,
                    y = hoodY[2] +1024,
                    width = 224,
                    height = 480,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B7
                    id = 38,
                    name = "B7",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +1024,
                    y = hoodY[2] +832,
                    width = 512,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B8
                    id = 38,
                    name = "B8",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +544,
                    y = hoodY[2] +544,
                    width = 416,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B9
                    id = 38,
                    name = "B9",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +576,
                    y = hoodY[2] +0704,
                    width = 64,
                    height = 64,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B10
                    id = 38,
                    name = "B10",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +544,
                    y = hoodY[2] +928,
                    width = 192,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },         
                {-- B11
                    id = 38,
                    name = "B11",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +800,
                    y = hoodY[2] +928,
                    width = 160,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B12
                    id = 38,
                    name = "B12",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +864,
                    y = hoodY[2] +704,
                    width = 64,
                    height = 64,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B13
                    id = 38,
                    name = "B13",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +544,
                    y = hoodY[2] +576 ,
                    width = 32,
                    height = 352,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B14
                    id = 38,
                    name = "B14",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +928,
                    y = hoodY[2] +608,
                    width = 32,
                    height = 320,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B15
                    id = 38,
                    name = "B15",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +1408,
                    y = hoodY[2],
                    width = 128,
                    height = 704,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla1
                    id = 38,
                    name = "Valla1",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +896,
                    y = hoodY[2] +176,
                    width = 64,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla2
                    id = 38,
                    name = "Valla2",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +960,
                    y = hoodY[2] +208,
                    width = 32,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla3
                    id = 38,
                    name = "Valla3",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +992,
                    y = hoodY[2] +176,
                    width = 64,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla4
                    id = 38,
                    name = "Valla4",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +1056,
                    y = hoodY[2]+210,
                    width = 64,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla5
                    id = 38,
                    name = "Valla5",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +1120,
                    y = hoodY[2]+242,
                    width = 64,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla5b
                    id = 38,
                    name = "Valla5b",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +1120,
                    y = hoodY[2]+256,
                    width = 68,
                    height = 12,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Vall6
                    id = 38,
                    name = "Vall6",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +1120,
                    y = hoodY[2]+368,
                    width = 38,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla7
                    id = 38,
                    name = "Valla7",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +1088,
                    y = hoodY[2]+400,
                    width = 38,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla8
                    id = 38,
                    name = "Valla8",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +1056,
                    y = hoodY[2]+432,
                    width = 38,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla9
                    id = 38,
                    name = "Valla9",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +992,
                    y = hoodY[2]+464,
                    width = 64,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla10
                    id = 38,
                    name = "Valla10",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +960,
                    y = hoodY[2]+432,
                    width = 32,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla11
                    id = 38,
                    name = "Valla11",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +896,
                    y = hoodY[2]+400,
                    width = 32,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla12
                    id = 38,
                    name = "Valla12",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +928,
                    y = hoodY[2]+368,
                    width = 32,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla13
                    id = 38,
                    name = "Valla13",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +864,
                    y = hoodY[2]+240,
                    width = 32,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla14
                    id = 38,
                    name = "Valla14",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +896,
                    y = hoodY[2]+192,
                    width = 1,
                    height = 64,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Valla15
                    id = 38,
                    name = "Valla15",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +864,
                    y = hoodY[2]+256,
                    width = 1,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B28
                    id = 38,
                    name = "B28",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2],
                    y = hoodY[2]+280,
                    width = 64,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B29
                    id = 38,
                    name = "B29",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +128,
                    y = hoodY[2] +280,
                    width = 64,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B30
                    id = 38,
                    name = "B30",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +190,
                    y = hoodY[2] +288,
                    width = 5,
                    height = 512,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B31
                    id = 38,
                    name = "B31",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +190,
                    y = hoodY[2] +800,
                    width = 320,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B32
                    id = 38,
                    name = "B32",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +190,
                    y = hoodY[2] +832,
                    width = 96,
                    height = 64,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B33
                    id = 38,
                    name = "B33",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +384,
                    y = hoodY[2] +832,
                    width = 96,
                    height = 64,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B34
                    id = 38,
                    name = "B34",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +480,
                    y = hoodY[2] +864,
                    width = 32,
                    height = 192,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B35
                    id = 38,
                    name = "B35",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2] +352,
                    y = hoodY[2] +1056,
                    width = 384,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- Parque1
                    id = 38,
                    name = "Parque1",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2],
                    y = hoodY[2]+320,
                    width = 5,
                    height = 864,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B36
                    id = 38,
                    name = "B36",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2]+352,
                    y = hoodY[2]+1088,
                    width = 128,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- B37
                    id = 38,
                    name = "B37",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[2]+512,
                    y = hoodY[2]+1024,
                    width = 224,
                    height = 96,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                
                
                {-- C-bas1
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+28,
                    y = hoodY[3],
                    width = 168,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                }, 
                {-- C-bas2 
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+194,
                    y = hoodY[3],
                    width = 1,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },                 
                {-- C-bas3
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+284,
                    y = hoodY[3],
                    width = 1,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                }, 
                {-- C-bas4
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+352,
                    y = hoodY[3],
                    width = 288,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- C-bas5

                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+288,
                    y = hoodY[3],
                    width = 448,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- C-bas6

                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+676,
                    y = hoodY[3],
                    width = 1,
                    height = 704,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- C-bas7
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+32,
                    y = hoodY[3]+704,
                    width = 704,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- C-bas8
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+28,
                    y = hoodY[3]+288,
                    width = 1,
                    height = 416,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- C-bas9
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+28,
                    y = hoodY[3],
                    width = 1,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- C-bas10
                    id = 38,
                    name = "C",  
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+608,
                    y = hoodY[3]+128,
                    width = 32,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- C-bas11 
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+352,
                    y = hoodY[3]+576,
                    width = 128,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {-- C-bas12
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+128,
                    y = hoodY[3]+672,
                    width = 32,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--venta
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+864,
                    y = hoodY[3]+64,
                    width = 288,
                    height = 94,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--venta
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+1184,
                    y = hoodY[3]+64,
                    width = 288,
                    height = 96,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--diag
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+1312,
                    y = hoodY[3]+288,
                    width = 160,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--diag
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+1152,
                    y = hoodY[3]+416,
                    width = 160,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--diag
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+1312,
                    y = hoodY[3]+480,
                    width = 160,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--diag
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+1376,
                    y = hoodY[3]+576,
                    width = 160,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--diag
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+1312,
                    y = hoodY[3]+704,
                    width = 160,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--diag
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+1376,
                    y = hoodY[3]+832,
                    width = 160,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--diag
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+1312,
                    y = hoodY[3]+960,
                    width = 160,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--diag
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+1376,
                    y = hoodY[3]+1088,
                    width = 160,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--home
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+832,
                    y = hoodY[3]+832,
                    width = 384,
                    height = 352,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--vall
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+224,
                    y = hoodY[3]+810,
                    width = 96,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--caucebott
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+672,
                    y = hoodY[3]+1516,
                    width = 64,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--cauce
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+672,
                    y = hoodY[3]+800,
                    width = 1,
                    height = 716,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--cauce
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+736,
                    y = hoodY[3]+800,
                    width = 1,
                    height = 716,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--cauce
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+736,
                    y = hoodY[3]+0,
                    width = 1,
                    height = 704,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--diag
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+800,
                    y = hoodY[3]+544,
                    width = 160,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--diag
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+992,
                    y = hoodY[3]+544,
                    width = 160,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--monte3
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+1312,
                    y = hoodY[3]+1312,
                    width = 128,
                    height = 192,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--mone1
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+1504,
                    y = hoodY[3]+1312,
                    width = 32,
                    height = 192,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--puente
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+672,
                    y = hoodY[3]+800,
                    width = 64,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--anden1
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+756,
                    y = hoodY[3]+1324,
                    width = 88,
                    height = 116,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--anden1
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+884,
                    y = hoodY[3]+1324,
                    width = 88,
                    height = 116,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--anden1
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+1012,
                    y = hoodY[3]+1324,
                    width = 88,
                    height = 116,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--anden1
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+1140,
                    y = hoodY[3]+1324,
                    width = 88,
                    height = 116,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--anden1
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+308,
                    y = hoodY[3]+1292,
                    width = 88,
                    height = 116,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--anden1    
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+436,
                    y = hoodY[3]+1292,
                    width = 88,
                    height = 116,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--anden2
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+308,
                    y = hoodY[3]+818,
                    width = 88,
                    height = 266,
                    rotation = 0,
                    visible = true,
                    properties = {}
                }, 
                {--anden2
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+436,
                    y = hoodY[3]+818,
                    width = 88,
                    height = 266,
                    rotation = 0,
                    visible = true,
                    properties = {}
                }, 
                {--anden4
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+20,
                    y = hoodY[3]+818,
                    width = 88,
                    height = 586,
                    rotation = 0,
                    visible = true,
                    properties = {}
                }, 
                {--anden4
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+148,
                    y = hoodY[3]+818,
                    width = 88,
                    height = 586,
                    rotation = 0,
                    visible = true,
                    properties = {}
                }, 
                {--anden4
                    id = 38,
                    name = "C",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[3]+564,
                    y = hoodY[3]+818,
                    width = 88,
                    height = 586,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },  


                {--D-almacen
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+32,
                    y = hoodY[4]+32,
                    width = 672,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                }, 
                {--D-super 
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4],
                    y = hoodY[4]+288,
                    width = 736,
                    height = 384,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },  
                {--D-sand  
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+448,
                    y = hoodY[4]+928,
                    width = 96,
                    height = 128,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },           
                {--D-roof 
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+608,
                    y = hoodY[4]+1024,
                    width = 32,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },     
                {--D-maquina
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+736,
                    y = hoodY[4]+672,
                    width = 1,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },  
                {--D-casa1
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+32,
                    y = hoodY[4]+1344,
                    width = 160,
                    height = 96,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },    
                {--D-maceta
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+96,
                    y = hoodY[4]+1440,
                    width = 32,
                    height = 64,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },  
                {--D-maceta
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+160,
                    y = hoodY[4]+1440,
                    width = 32,
                    height = 64,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },  
                {--D-obra
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+320,
                    y = hoodY[4]+1312,
                    width = 896,
                    height = 160,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },  
                {--D-obra
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+832,
                    y = hoodY[4]+832,
                    width = 1,
                    height = 480,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },  
                {--D-obra
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+1216,
                    y = hoodY[4]+832,
                    width = 1,
                    height = 480,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },                                           
                {--D-crop
 
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+1344,
                    y = hoodY[4]+1216,
                    width = 96,
                    height = 256,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },  
                {--D-crop
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+1440,
                    y = hoodY[4]+1440,
                    width = 64,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },  
                {--D-crop

                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+1472,
                    y = hoodY[4]+1184,
                    width = 32,
                    height = 256,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },  
                {--D-casa2 
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+1376,
                    y = hoodY[4]+1056,
                    width = 128,
                    height = 96,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },  
                {--D-monte

                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+1344,
                    y = hoodY[4]+832,
                    width = 32,
                    height = 64,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },  
                {--D-monte

                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+1440,
                    y = hoodY[4]+832,
                    width = 64,
                    height = 192,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },                                       
                {--D-asent
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+896,
                    y = hoodY[4],
                    width = 640,
                    height = 192,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },  
                {--D-asent
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+896,
                    y = hoodY[4] +192,
                    width = 128,
                    height = 480,
                    rotation = 0,
                    visible = true,
                    properties = {}
                }, 
                {--D-asent 
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+896,
                    y = hoodY[4] +672,
                    width = 128,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                }, 
                {--D-asent 
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+1408,
                    y = hoodY[4]+288,
                    width = 128,
                    height = 384,
                    rotation = 0,
                    visible = true,
                    properties = {}
                }, 
                {--D-asent 
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+1152,
                    y = hoodY[4]+288,
                    width = 256,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                }, 
                {--D-asent
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+1152,
                    y = hoodY[4]+320,
                    width = 128,
                    height = 288,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--D-asent
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+1152,
                    y = hoodY[4]+672,
                    width = 384,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },

                {--D-valla
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+192,
                    y = hoodY[4]+1216,
                    width = 1,
                    height = 32,
                    rotation = 0,
                    visible = true,
                    properties = {}
                }, 
                {--D-valla
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4],
                    y = hoodY[4]+1216,
                    width = 192,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },                      
                {--D-valla
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4],
                    y = hoodY[4]+672,
                    width = 1,
                    height = 576,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {--D-valla
                    id = 38,
                    name = "D",
                    type = "",
                    shape = "rectangle",
                    x = hoodX[4]+832,
                    y = hoodY[4]+832,
                    width = 384,
                    height = 1,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
            }
        }
    }
}

return MapData