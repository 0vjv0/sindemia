--[[Creates spawn points for player, endLEvel and npcs]]

-- Center of hood (inside road)
local center = 236

-- Hood width and heigt
local hood = 512

-- Player spawn coords
local random_player_coordX = center + (hood * love.math.random(0,7))
local random_player_coordY = center + (hood * love.math.random(0,7))

-- endLevel coords. 4 hoods right away and above player spawn
local endLevel_coordX = random_player_coordX + (4 * hood)
local endLevel_coordY = random_player_coordY + (4 * hood)

--if endLevel is outside map limits (rigth [X = 3876] bottom [Y = 3845]), spwan 4 hoods to the left or up
if endLevel_coordX > 3876 then
    endLevel_coordX = random_player_coordX - (4 * hood)
end
if endLevel_coordY > 3845 then
    endLevel_coordY = random_player_coordY - (4 * hood)
end

-- Player and endLevel to map 
local objects =
{
    {-- Player
        id = 1,
        name = "spawn",
        type = "player",
        shape = "rectangle",
        x = random_player_coordX,
        y = random_player_coordY,
        width = 64,
        height = 64,
        rotation = 0,
        visible = false,
        properties = {}
    },
    {--Endlevel
        id = 2,
        name = "endLevel",
        type = "endLevel",
        shape = "rectangle",
        x = endLevel_coordX,
        y = endLevel_coordY,
        width = 32,
        height = 32,
        rotation = 0,
        visible = true,
        properties = {}
    },
}

--NPCs coord. inside map
local npcs = {}
local npcsX = {-3, -2, -1, 0, 1, 2, 3}
local npcsY = {-3, -2, -1, 0, 1, 2, 3}
local Xlimits = {190,3876}
local Ylimits = {176,3845}

--NPCs inside map limits
for i=1,3 do
  if random_player_coordX + (hood * npcsX[i]) < Xlimits[1] then
    npcsX[i] = npcsX[i] +7
  end
  if random_player_coordY + (hood * npcsY[i]) < Ylimits[1] then
    npcsY[i] = npcsY[i] +7
  end
end
for i=7,5,-1 do
  if random_player_coordX + (hood * npcsX[i]) > Xlimits[2] then
    npcsX[i] = npcsX[i] -7
  end
  if random_player_coordY + (hood * npcsY[i]) > Ylimits[2] then
    npcsY[i] = npcsY[i] -7
  end
end

--Populate npcs list 
local n = 0

for i=1,7 do
  for j=1,7 do
    n = n + 1

    -- Exclude player coords.
    if npcsX[i] == 0 and npcsY[j] == 0 then
    
    else
      npcs[n] = {
        id = 2 + n,
        name = "npc1", -- All npc1
        type = "",
        shape = "rectangle",
        x = random_player_coordX + (hood * npcsX[i]),
        y = random_player_coordY + (hood * npcsY[j]) -64,
        width = 64,
        height = 64,
        rotation = 0,
        visible = true,
        properties = {}
        }
    end
  end
end

-- Change name of npc2 and npc3
for i=18,32,2 do
    npcs[i].name = "npc2"
end

for i=9,41,3 do
    npcs[i].name = "npc3"
end

-- NPCs to table 
for i=1,#npcs do
    table.insert(objects, npcs[i])
end

return objects
