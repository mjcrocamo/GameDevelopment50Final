--[[
    GD50
    Final Project

    -- GameOverState Class --

]]

GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    self.map = LevelMaker.generate(100, 10)
    self.background = math.random(2)
end

function GameOverState:enter(params)

  if params ~= nil then
    self.score = params.score
    self.levelcount = params.levelcount
  end

  if self.levelcount == nil then self.levelcount = 1 end

end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function GameOverState:render()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0, 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0,
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    self.map:render()

    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf("Game Over", 1, VIRTUAL_HEIGHT / 2 - 40 + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf("Game Over", 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Score:' ..tostring(self.score), 1, VIRTUAL_HEIGHT / 2 - 12 , VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Score:' ..tostring(self.score), 0, VIRTUAL_HEIGHT / 2 - 11, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Level:' ..tostring(self.levelcount), 1, VIRTUAL_HEIGHT / 2 + 2, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Level:' ..tostring(self.levelcount), 0, VIRTUAL_HEIGHT / 2 + 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Press Enter to Play Again', 1, VIRTUAL_HEIGHT / 2 + 17, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Press Enter to Play Again', 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
end
