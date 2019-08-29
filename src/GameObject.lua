--[[
    GD50
    Final Project

    --GameObject --
]]

GameObject = Class{}

function GameObject:init(def)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.width = def.width
    self.height = def.height
    self.frame = def.frame
    self.solid = def.solid
    self.collidable = def.collidable
    self.consumable = def.consumable
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.hit = def.hit
    self.type = def.type
    self.opacity = 255
end

function GameObject:collides(target)
    return not (target.x > self.x + self.width - 7 or self.x + 5 > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function GameObject:update(dt)

end

function GameObject:render()
    love.graphics.setColor(255, 255, 255, self.opacity)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)
end
