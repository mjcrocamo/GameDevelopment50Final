--[[
    GD50
    Final Project 

    -- AnimalMovingState Class --

]]

AnimalMovingState = Class{__includes = BaseState}

function AnimalMovingState:init(tilemap, player, animal)
    self.tilemap = tilemap
    self.player = player
    self.animal = animal
    self.animation = self.animal.animationMoving
    self.animal.currentAnimation = self.animation

    self.movingDirection = math.random(2) == 1 and 'left' or 'right'
    self.animal.direction = self.movingDirection
    self.movingDuration = math.random(5)
    self.movingTimer = 0
end

function AnimalMovingState:update(dt)
    self.movingTimer = self.movingTimer + dt
    self.animal.currentAnimation:update(dt)

    -- reset movement direction and timer if timer is above duration
    if self.movingTimer > self.movingDuration then

        -- chance to go into idle state randomly
        if math.random(4) == 1 then
            self.animal:changeState('idle', {

                -- random amount of time for snail to be idle
                wait = math.random(5)
            })
        else
            self.movingDirection = math.random(2) == 1 and 'left' or 'right'
            self.animal.direction = self.movingDirection
            self.movingDuration = math.random(5)
            self.movingTimer = 0
        end
    elseif self.animal.direction == 'left' then
        self.animal.x = self.animal.x - ANIMAL_MOVE_SPEED * dt

        -- stop the snail if there's a missing tile on the floor to the left or a solid tile directly left
        local tileLeft = self.tilemap:pointToTile(self.animal.x, self.animal.y)
        local tileBottomLeft = self.tilemap:pointToTile(self.animal.x, self.animal.y + self.animal.height)

        if (tileLeft and tileBottomLeft) and (tileLeft:collidable() or not tileBottomLeft:collidable()) then
            self.animal.x = self.animal.x + ANIMAL_MOVE_SPEED * dt

            -- reset direction if we hit a wall
            self.movingDirection = 'right'
            self.animal.direction = self.movingDirection
            self.movingDuration = math.random(5)
            self.movingTimer = 0
        end
    else
        self.animal.direction = 'right'
        self.animal.x = self.animal.x + ANIMAL_MOVE_SPEED * dt

        -- stop the snail if there's a missing tile on the floor to the right or a solid tile directly right
        local tileRight = self.tilemap:pointToTile(self.animal.x + self.animal.width, self.animal.y)
        local tileBottomRight = self.tilemap:pointToTile(self.animal.x + self.animal.width, self.animal.y + self.animal.height)

        if (tileRight and tileBottomRight) and (tileRight:collidable() or not tileBottomRight:collidable()) then
            self.animal.x = self.animal.x - ANIMAL_MOVE_SPEED * dt

            -- reset direction if we hit a wall
            self.movingDirection = 'left'
            self.animal.direction = self.movingDirection
            self.movingDuration = math.random(5)
            self.movingTimer = 0
        end
    end

    -- calculate difference between snail and player on X axis
    -- and only chase if <= 5 tiles
    local diffX = math.abs(self.player.x - self.animal.x)

    if diffX < 5 * TILE_SIZE then
        self.animal:changeState('chasing')
    end
end
