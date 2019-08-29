--[[
    GD50
    Final Project

    --Animal Chasing State --
]]

AnimalChasingState = Class{__includes = BaseState}

function AnimalChasingState:init(tilemap, player, animal)
    self.tilemap = tilemap
    self.player = player
    self.animal = animal
    self.animation = self.animal.animationMoving
    self.animal.currentAnimation = self.animation
end

function AnimalChasingState:update(dt)
    self.animal.currentAnimation:update(dt)

    -- calculate difference between snail and player on X axis
    -- and only chase if <= 5 tiles
    local diffX = math.abs(self.player.x - self.animal.x)

    if diffX > 5 * TILE_SIZE then
        self.animal:changeState('moving')
    elseif self.player.x < self.animal.x then
        self.animal.direction = 'left'
        self.animal.x = self.animal.x - ANIMAL_MOVE_SPEED * dt

        -- stop the snail if there's a missing tile on the floor to the left or a solid tile directly left
        local tileLeft = self.tilemap:pointToTile(self.animal.x, self.animal.y)
        local tileBottomLeft = self.tilemap:pointToTile(self.animal.x, self.animal.y + self.animal.height)

        if (tileLeft and tileBottomLeft) and (tileLeft:collidable() or not tileBottomLeft:collidable()) then
            self.animal.x = self.animal.x + ANIMAL_MOVE_SPEED * dt
        end
    else
        self.animal.direction = 'right'
        self.animal.x = self.animal.x + ANIMAL_MOVE_SPEED * dt

        -- stop the snail if there's a missing tile on the floor to the right or a solid tile directly right
        local tileRight = self.tilemap:pointToTile(self.animal.x + self.animal.width, self.animal.y)
        local tileBottomRight = self.tilemap:pointToTile(self.animal.x + self.animal.width, self.animal.y + self.animal.height)

        if (tileRight and tileBottomRight) and (tileRight:collidable() or not tileBottomRight:collidable()) then
            self.animal.x = self.animal.x - ANIMAL_MOVE_SPEED * dt
        end
    end

end
