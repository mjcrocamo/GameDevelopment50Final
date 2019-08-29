--[[
    GD50

    -- AnimalIdleState Class --
]]

BombTriggeredState = Class{__includes = BaseState}

function BombTriggeredState:init(tilemap, player, bomb)
    self.tilemap = tilemap
    self.player = player
    self.bomb = bomb
    self.BombTimer = 3
    self.animation = self.bomb.animationMoving
    self.bomb.currentAnimation = self.animation
end

function BombTriggeredState:enter(params)
  if params == nil then
    self.waitPeriod = 0
  end
end

function BombTriggeredState:update(dt)

  self.bomb.currentAnimation:update(dt)

    -- calculate difference between bomb and player on X axis
    -- and only chase if <= 4 tiles
    local diffX = math.abs(self.player.x - self.bomb.x)
    local diffY = math.abs(self.player.y + self.player.height - self.bomb.y)

    if self.bomb:collides(self.player) and not self.player.powerup then

      gSounds['explosion']:play()

      for k, entity in pairs(self.player.level.entities) do
          local diffEX = math.abs(entity.x - self.bomb.x)
          if diffEX < 4 * TILE_SIZE then
            table.remove(self.player.level.entities, k)
          end
      end


      if diffX < 4 * TILE_SIZE and diffY < 1 * TILE_SIZE then
        self.player:damage(1)
        self.player:goInvulnerable(2)
        gSounds['hit-player']:play()

        if self.player.health == 0 then
          gSounds['death']:play()
          gStateMachine:change('game-over', {
            score = self.player.score,
            level = self.player.levelnumber
          })
        end
      end
    end


    self.BombTimer = self.BombTimer - dt

    if self.BombTimer <= 0 and not self.player.powerup then

      gSounds['explosion']:play()

      for k, entity in pairs(self.player.level.entities) do
        local diffEX = math.abs(entity.x - self.bomb.x)
        if diffEX < 4 * TILE_SIZE then
          table.remove(self.player.level.entities, k)
        end
      end

      if diffX < 4 * TILE_SIZE then
        self.player:damage(1)
        self.player:goInvulnerable(2)
        gSounds['hit-player']:play()

        if self.player.health == 0 then
          gSounds['death']:play()
          gStateMachine:change('game-over', {
            score = self.player.score,
            level = self.player.levelnumber
          })
      end
    end
  end
end
