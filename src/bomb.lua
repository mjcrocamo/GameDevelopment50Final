--[[
    GD50
    Final Project

    - Bomb Class --
    Entity
]]

Bomb = Class{__includes = Entity}

function Bomb:init(def)
    Entity.init(self, def)
    self.canExplode = true
end

function Bomb:render()
  love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
      math.floor(self.x) + 8, math.floor(self.y) + 8, 0, self.direction == 'left' and 1 or -1, 1, 8, 10)
end
