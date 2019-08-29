--[[
    GD50
    Final project

    --Player Idle State --
]]

PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player

    self.animation = Animation {
        frames = {4},
        interval = 1
    }
    self.player.currentAnimation = self.animation

end

function PlayerIdleState:update(dt)

  self.player.currentAnimation:update(dt)

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        self.player:changeState('walking')
    end

    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end

    -- check if we've collided with any entities and die if so
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) and not self.player.invulnerable then

          self.player:damage(1)
          self.player:goInvulnerable(2)
          gSounds['hit-player']:play()

          if self.player.health == 0 then
            gSounds['death']:play()
            gStateMachine:change('game-over', {
              score = self.player.score,
              levelcount = self.player.levelnumber
            })
          end

        end
    end
end
