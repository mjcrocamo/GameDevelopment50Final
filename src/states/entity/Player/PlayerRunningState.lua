
--[[
    GD50
    Final Project

    -- PLayer Running State --

    Special power up state where player is invincible and increases
    speed. Killing all entities in his path
]]

PlayerRunningState = Class{__includes = BaseState}

function PlayerRunningState:init(player)
    self.player = player

    self.animation = Animation {
        frames = {4,5,6},
        interval = .05
    }
    self.player.currentAnimation = self.animation

    self.runtimer = 2
end

function PlayerRunningState:update(dt)

    self.player.currentAnimation:update(dt)

    self.runtimer = self.runtimer - dt

    if self.runtimer <= 0 then
      self.player:changeState('idle')
      self.player.powerup = false
    else
      self.player.powerup = true

      gSounds['running']:play()

      local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
      local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)

      -- temporarily shift player down a pixel to test for game objects beneath
      self.player.y = self.player.y + 1

      local collidedObjects = self.player:checkObjectCollisions()

      self.player.y = self.player.y - 1

      self.player.x = self.player.x + PLAYER_RUN_SPEED * dt

      -- check if we've collided with any entities and kill them
      for k, entity in pairs(self.player.level.entities) do
          if entity:collides(self.player) then

            gSounds['kill']:play()
            gSounds['kill2']:play()
            self.player.score = self.player.score + 100
            table.remove(self.player.level.entities, k)

          end
      end
    end
end
