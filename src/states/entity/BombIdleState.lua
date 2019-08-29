--[[
    GD50

    -- AnimalIdleState Class --
]]

BombIdleState = Class{__includes = BaseState}

function BombIdleState:init(tilemap, player, bomb)
    self.tilemap = tilemap
    self.player = player
    self.bomb = bomb
    self.BombTimer = 20
    self.animation = self.bomb.animationIdle
    self.bomb.currentAnimation = self.animation
end

function BombIdleState:enter(params)
  if params == nil then
    self.waitPeriod = 0
  end
end

function BombIdleState:update(dt)

  self.bomb.currentAnimation:update(dt)

    -- calculate difference between bomb and player on X axis
    -- and only chase if <= 5 tiles
    local diffX = math.abs(self.player.x - self.bomb.x)

    if diffX < 4 * TILE_SIZE then
      self.bomb:changeState('trigger')
    end

end
