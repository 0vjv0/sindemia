--[[
    Manages the scenes or transitions between levels or game states.
    Developed by Delisa
    https://git.drk.sc/kattrali/love-template
]]

local sti = require 'lib.sti'
local anim8 = require 'lib.anim8'
local Camera = require 'lib.camera'

local SceneDSL = function()
  local camera = Camera()
  camera:setFollowStyle('TOPDOWN')

  local scene = {
    done = false,
    awaiting_dialog_keyreleased = false,
    assets = {},
    groups = {},
    persistent_group = nil,
    groupindex = 1,
  }

  local function apply_xy_transform(dt, context, transform, duration, xprop, yprop, dxprop, dyprop)
    transform.elapsed = transform.elapsed + dt
    if transform.elapsed <= duration then
      context[xprop] = context[xprop] + (transform[dxprop] * dt/duration)
      context[yprop] = context[yprop] + (transform[dyprop] * dt/duration)
    end
  end

  local function newGroup(items)
    local group = {loaded=false, duration=0, elapsed=0, renderers={}, contexts={}, transforms={}}
    function group:init()
      if not self.loaded then
        for _, item in ipairs(self.transforms) do
          if item.transform.init ~= nil then
            local context
            if item.asset_id ~= nil then
              context = self.contexts[item.asset_id]
            end
            item.transform:init(context)
          end
        end
        self.loaded = true
      end
    end

    function group:update(dt)
      self:init()
      for _, item in ipairs(self.transforms) do
        local asset, context
        if item.asset_id ~= nil then
          asset = scene.assets[item.asset_id]
          context = self.contexts[item.asset_id]
        end
        item.transform:apply(asset, context, dt)
      end
      self.elapsed = self.elapsed + dt
    end

    function group:draw()
      for _, renderer in ipairs(self.renderers) do
        if renderer.asset_id ~= nil then
          local asset = scene.assets[renderer.asset_id]
          local context = self.contexts[renderer.asset_id]
          renderer.draw(asset, context)
        else
          renderer.draw(nil, renderer.context)
        end
      end
    end

    for _, item in pairs(items) do
      if item.context ~= nil and item.asset_id ~= nil then
        group.contexts[item.asset_id] = item.context
      end
      if item.transform ~= nil then
        table.insert(group.transforms, item)
      end
      if item.draw ~= nil then
        table.insert(group.renderers, item)
      end
      if item.duration ~= nil and item.duration > group.duration then
        group.duration = item.duration
      end
      if item.await_dialog == true then
        group.await_dialog = true
      end
    end
    return group
  end

  -- Cache resources for later use
  function scene.load_resources(items)
    for _, asset in ipairs(items) do
      scene.assets[asset.id] = asset
    end
  end

  function scene.audio_add(id, filepath)
    return {id=id, data={source=love.audio.newSource(filepath, "static")}}
  end

  function scene.audio_play(id)
    return {
      asset_id=id,
      transform={
        apply=function(self, asset, _, dt)
          if self.applied ~= true then
            love.audio.play(asset.data.source)
            self.applied = true
          end
        end
      }}
  end

  function scene.audio_stop(id)
    return {
      asset_id=id,
      transform={
        apply=function(self, asset, _, dt)
          if self.applied ~= true then
            love.audio.stop(asset.data.source)
            self.applied = true
          end
        end
      }}
  end

  function scene.audio_pause(id)
    return {
      asset_id=id,
      transform={
        apply=function(self, asset, _, dt)
          if self.applied ~= true then
            love.audio.pause(asset.data.source)
            self.applied = true
          end
        end
      }}
  end

  function scene.map_add(id, map_path)
    return {id=id, data={map=sti(map_path)}}
  end

  function scene.camera_follow(map_id, other_id)
    local target = scene.assets[other_id]
    return {asset_id=map_id, transform={
      apply=function(self, _, _, dt)
        camera:follow(target.x, target.y)
      end
    }}
  end

  function scene.screen_shake(duration, intensity, frequency)
    return {
      duration=duration,
      transform={
        apply=function(self, _, _, dt)
          if self.applied ~= true then
            camera:shake(duration, intensity or 8, frequency or 60)
            self.applied = true
          end
        end
      }}
  end

  function scene.screen_fade(duration, color)
    return {
      duration=duration,
      transform={
        apply=function(self, _, _, dt)
          if self.applied ~= true then
            camera:fade(duration, color or {0, 0, 0, 255})
            self.applied = true
          end
        end
      }}
  end

  function scene.map_draw(id)
    return {
      asset_id=id,
      context={x=0, y=0},
      draw=function(asset, ctx)
        asset.data.map:draw(-ctx.x, -ctx.y, 1, 1)
      end,
      transform={
        apply=function(self, asset, ctx, dt)
          local windowWidth  = love.graphics.getWidth()
          local windowHeight = love.graphics.getHeight()
          local mapMaxWidth = asset.data.map.width * asset.data.map.tilewidth
          local mapMaxHeight = asset.data.map.height * asset.data.map.tileheight
          ctx.x = math.min(math.max(0, camera.x - windowWidth/2), mapMaxWidth - windowWidth)
          ctx.y = math.min(math.max(0, camera.y - windowHeight/2), mapMaxHeight - windowHeight)
          asset.data.map:update(dt)
        end
      }
    }
  end

  function scene.sprite_add(id, path, x, y, w, h)
    local image = love.graphics.newImage(path)
    local quad = love.graphics.newQuad(x, y, w, h, image:getWidth(), image:getHeight())
    return {id=id, data={quad=quad, image=image}}
  end

  function scene.sprite_draw(id, x, y, sx, sy, radians)
    return {
      asset_id=id,
      context={x=x, y=y, sx=sx or 1, sy=sy or 1, radians=radians or 0},
      draw=function(asset, ctx)
        love.graphics.draw(asset.data.image, asset.data.quad, ctx.x,
                           ctx.y, ctx.radians, ctx.sx, ctx.sy)
      end
    }
  end

  function scene.sprite_move(id, dx, dy, duration)
    return {
      asset_id=id,
      duration=duration,
      transform={
        elapsed=0,
        dx=dx,
        dy=dy,
        apply=function(self, _, ctx, dt)
          apply_xy_transform(dt, ctx, self, duration, "x", "y", "dx", "dy")
        end
      }
    }
  end

  function scene.sprite_move_to(id, target_x, target_y, duration)
    local directive = scene.sprite_move(id, 0, 0, duration)
    directive.transform.init=function(self, ctx)
      self.dx = target_x - ctx.x
      self.dy = target_y - ctx.y
    end
    return directive
  end

  function scene.sprite_scale(id, target_sx, target_sy, duration)
    return {
      asset_id=id,
      duration=duration,
      transform={
        elapsed=0,
        init=function(self, ctx)
          self.dsx = target_sx - ctx.sx
          self.dsy = target_sy - ctx.sy
        end,
        apply=function(self, _, ctx, dt)
          apply_xy_transform(dt, ctx, self, duration, "sx", "sy", "dsx", "dsy")
        end
      }
    }
  end

  function scene.sprite_rotate(id, radians, duration)
    return {
      asset_id=id,
      duration=duration,
      transform={
        elapsed=0,
        init=function(self, ctx)
          self.dradians = radians - ctx.radians
        end,
        apply=function(self, _, ctx, dt)
          self.elapsed = self.elapsed + dt
          if self.elapsed <= duration then
            ctx.radians = ctx.radians + self.dradians * (dt/duration)
          end
        end,
      }
    }
  end

  function scene.image_add(id, path)
    return {id=id, data={image=love.graphics.newImage(path)}}
  end

  function scene.image_draw(id, x, y)
    return {
      asset_id=id,
      context={x=x, y=y},
      draw=function(asset, ctx)
        love.graphics.draw(asset.data.image, ctx.x, ctx.y)
      end
    }
  end

  function scene.anim_add(id, path, w, h, frame_count, frame_duration)
    local image = love.graphics.newImage(path)
    local g = anim8.newGrid(w, h, image:getWidth(), image:getHeight())
    local animation = anim8.newAnimation(g('1-'..frame_count,1), frame_duration)
    return {id=id, data={animation=animation, image=image}}
  end

  function scene.anim_draw(id, x, y)
    return {
      asset_id=id,
      context={x=x, y=y},
      draw=function(asset, ctx)
        asset.data.animation:draw(asset.data.image, ctx.x, ctx.y)
      end,
      transform={
        apply=function(self, asset, _, dt)
          asset.data.animation:update(dt)
        end
      }
    }
  end

  function scene.group(items)
    table.insert(scene.groups, newGroup(items))
  end

  function scene.all_groups(items)
    scene.persistent_group = newGroup(items)
  end

  function scene.wait(duration)
    return {duration=duration}
  end

  function scene.auto_dialog(x, y, duration, text)
    return {
      duration=duration,
      context={text=text, x=x, y=y},
      draw=function(_, ctx)
        love.graphics.print(ctx.text, ctx.x, ctx.y)
      end
    }
  end

  function scene.dialog(x, y, text)
    return {
      await_dialog=true,
      context={text=text, x=x, y=y},
      draw=function(_, ctx)
        love.graphics.print(ctx.text, ctx.x, ctx.y)
      end
    }
  end

  -- Callbacks
  function scene.dialogkeyreleased()
    local group = scene.groups[scene.groupindex]
    group.await_dialog = false
  end

  function scene.update(dt)
    scene.screen_w = love.graphics.getWidth()
    scene.screen_h = love.graphics.getHeight()

    camera:update(dt)
    if scene.persistent_group ~= nil then
      scene.persistent_group:update(dt)
    end
    local group = scene.groups[scene.groupindex]
    group:update(dt)
    scene.awaiting_dialog_keyreleased = group.await_dialog
    if group.elapsed >= group.duration and group.await_dialog ~= true then
      if scene.groupindex == #scene.groups then
        scene.done = true
      else
        scene.groupindex = scene.groupindex + 1
      end
    end
  end

  function scene.draw()
    camera:attach()
    if scene.persistent_group ~= nil then
      scene.persistent_group:draw()
    end
    scene.groups[scene.groupindex]:draw()
    camera:detach()
    camera:draw()
  end

  function scene.END()
    return scene
  end

  -- TODO: implement these:
  function scene.anim_move(id, x, y, duration)
    error("not implemented")
  end

  function scene.camera_rotate(radians, duration)
    error("not implemented")
  end

  function scene.camera_zoom(ratio, duration)
    error("not implemented")
  end

  function scene.camera_move_to(x, y, duration)
    error("not implemented")
  end

  function scene.camera_move(dx, dy, duration)
    error("not implemented")
  end

  function scene.image_rotate(id, radians, duration)
    error("not implemented")
  end

  function scene.image_scale(id, sx, sy, duration)
    error("not implemented")
  end

  function scene.image_move(id, dx, dy, duration)
    error("not implemented")
  end

  function scene.image_move_to(id, x, y, duration)
    error("not implemented")
  end

  return scene
end

local function readfile(path)
  local file = io.open(path, "rb")
  local content = file:read("*a")
  file:close()
  return content
end

return function(scene_file_path)
  local content = readfile(scene_file_path)
  content = content .. "\nreturn END()"
  local scene = load(content, scene_file_path, nil, SceneDSL())
  return scene()
end
