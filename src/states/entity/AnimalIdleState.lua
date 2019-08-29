--[[
    GD50
    Final Project

    -- AnimalIdleState Class --
]]

AnimalIdleState = Class{__includes = BaseState}

function AnimalIdleState:init(tilemap, player, animal)
    self.tilemap = tilemap
    self.player = player
    self.animal = animal
    self.waitTimer = 0
    self.animation = self.animal.animationIdle
    self.animal.currentAnimation = self.animation
end

function AnimalIdleState:enter(params)
    self.waitPeriod = params.wait
end

function AnimalIdleState:update(dt)

  self.animal.currentAnimation:update(dt)

    if self.waitTimer < self.waitPeriod then
        self.waitTimer = self.waitTimer + dt
    else
        self.animal:changeState('moving')
    end

    -- calculate difference between snail and player on X axis
    -- and only chase if <= 5 tiles
    local diffX = math.abs(self.player.x - self.animal.x)

    if diffX < 5 * TILE_SIZE then
        self.animal:changeState('chasing')
    end
end
