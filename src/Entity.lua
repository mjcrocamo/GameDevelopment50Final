--[[
    GD50
    Final project

    -- Entity Class --

]]

Entity = Class{}

function Entity:init(def)
    -- position
    self.x = def.x
    self.y = def.y

    -- velocity
    self.dx = 0
    self.dy = 0

    -- dimensions
    self.width = def.width
    self.height = def.height

    self.texture = def.texture
    self.stateMachine = def.stateMachine

    self.direction = def.direction or 'left'

    -- reference to tile map so we can check collisions
    self.map = def.map

    -- reference to level for tests against other entities + objects
    self.level = def.level

    self.health = def.health

    self.animationIdle = def.animationIdle
    self.animationMoving = def.animationMoving

    -- flags for flashing the entity when hit
    self.invulnerable = false
    self.invulnerableDuration = 0
    self.invulnerableTimer = 0

    -- timer for turning transparency on and off, flashing
    self.flashTimer = 0


end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:update(dt)

  if self.invulnerable then
      self.flashTimer = self.flashTimer + dt
      self.invulnerableTimer = self.invulnerableTimer + dt

      if self.invulnerableTimer > self.invulnerableDuration then
          self.invulnerable = false
          self.invulnerableTimer = 0
          self.invulnerableDuration = 0
          self.flashTimer = 0
      end
  end
    self.stateMachine:update(dt)
end

function Entity:damage(dmg)
    self.health = self.health - dmg
end

function Entity:goInvulnerable(duration)
    self.invulnerable = true
    self.invulnerableDuration = duration
end

function Entity:collides(entity)
    return not (self.x > entity.x + entity.width or entity.x > self.x + self.width or
                self.y > entity.y + entity.height or entity.y > self.y + self.height)
end

function Entity:render()
  -- draw sprite slightly transparent if invulnerable every 0.04 seconds
  if self.invulnerable and self.flashTimer > 0.06 then
      self.flashTimer = 0
      love.graphics.setColor(255, 255, 255, 64)
  end

    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8, math.floor(self.y) + 10, 0, self.direction == 'right' and 1 or -1, 1, 8, 10)
end
