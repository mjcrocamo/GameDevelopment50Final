
--[[
    GD50
    Final Project

    --PLayer Walking State --
]]

PlayerWalkingState = Class{__includes = BaseState}

function PlayerWalkingState:init(player)
    self.player = player

    self.animation = Animation {
        frames = {4,5,6},
        interval = .2
    }
    self.player.currentAnimation = self.animation
end

function PlayerWalkingState:update(dt)

    self.player.currentAnimation:update(dt)

    -- idle if we're not pressing anything at all
    if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
        self.player:changeState('idle')
    else
      -- give more lee way so the character falls more naturally.

        local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
        local tileBottomRight = self.player.map:pointToTile(self.player.x - 4 + self.player.width - 1, self.player.y + self.player.height)

        -- temporarily shift player down a pixel to test for game objects beneath
        self.player.y = self.player.y + 1

        local collidedObjects = self.player:checkObjectCollisions()

        self.player.y = self.player.y - 1

        -- check to see whether there are any tiles beneath us
        if #collidedObjects == 0 and (tileBottomLeft and tileBottomRight) and (not tileBottomLeft:collidable() and not tileBottomRight:collidable()) then
            self.player.dy = 0
            self.player:changeState('falling')
        elseif love.keyboard.isDown('left') then
            self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
            self.player.direction = 'left'
            self.player:checkLeftCollisions(dt)
        elseif love.keyboard.isDown('right') then
            self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
            self.player.direction = 'right'
            self.player:checkRightCollisions(dt)
        end
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

    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end

end
