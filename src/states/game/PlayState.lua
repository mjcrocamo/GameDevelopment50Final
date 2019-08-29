--[[
    GD50
    Final Project

    -- PlayState Class --
]]

PlayState = Class{__includes = BaseState}


function PlayState:init()
    self.camX = 0
    self.camY = 0
    self.levelcount = 1
    self.levellength = math.random(10, 20)
    self.level = LevelMaker.generate(10 * self.levellength, 10)
    self.tileMap = self.level.tileMap
    self.background = math.random(2)
    self.backgroundX = 0

    self.gravityOn = true
    self.gravityAmount = 6


    self.player = Player({
        x = 0, y = 0,
        width = 16, height = 20,
        texture = 'pirate',
        health = 6,
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
            ['falling'] = function() return PlayerFallingState(self.player, self.gravityAmount) end,
            ['running'] = function() return PlayerRunningState(self.player, self.gravityAmount) end,
            ['throw-bomb'] = function() return PlayerBombState(self.player, self.dungeon) end

        },
        map = self.tileMap,
        level = self.level
    })

    self:spawnEnemies()

    self.player:changeState('falling')
end

function PlayState:enter(params)
  if params == nil then
    self.player.score = 0
    self.player.health = 6
    self.player.levelnumber = 1
  else
    self.player.score = params.score
    self.player.health = params.health
    self.player.levelnumber = params.levelnumber
  end

  self.levelcount = self.levelcount + 1

end


function PlayState:update(dt)
    Timer.update(dt)

    -- remove any nils from pickups, etc.
    self.level:clear()

    -- update player and level
    self.player:update(dt)
    self.level:update(dt)
    self:updateCamera()

    -- constrain player X no matter which state
    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > TILE_SIZE * self.tileMap.width - self.player.width then
        self.player.x = TILE_SIZE * self.tileMap.width - self.player.width
    end
end

function PlayState:render()
    love.graphics.push()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 270), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 270),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)

    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    self.level:render()

    self.player:render()
    love.graphics.pop()

    -- render score and level
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('Score:'..tostring(self.player.score), 5, 5)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('Score:'..tostring(self.player.score), 4, 4)

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('Level:' ..tostring(self.player.levelnumber), 5, 19)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('Level:' ..tostring(self.player.levelnumber), 4, 20)

    -- draw player hearts, top of screen
    local healthLeft = self.player.health
    local heartFrame = 1

    for i = 1, 3 do
        if healthLeft > 1 then
            heartFrame = 5
        elseif healthLeft == 1 then
            heartFrame = 3
        else
            heartFrame = 1
        end

        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][heartFrame],
            (i - 1) * (TILE_SIZE + 1) + (VIRTUAL_WIDTH - (TILE_SIZE * 3) - 10), 5)

        healthLeft = healthLeft - 2
    end

end

function PlayState:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % 256
end

--[[
    Adds a series of enemies to the level randomly.
]]
function PlayState:spawnEnemies()
    -- spawn entities in the level
    for x = 1, self.tileMap.width do

        -- flag for whether there's ground on this column of the level
        local groundFound = false

        for y = 1, self.tileMap.height do
            if not groundFound then
                if self.tileMap.tiles[y][x].id == TILE_ID_GROUND then
                    groundFound = true

                    -- random chance to generate enemies, more enemies as levels get higher
                    if math.random(math.max(30 - self.player.levelnumber, 5)) == 1 then

                        -- instantiate snapper fish, snail, and shark

                        --[[
                            Randomly creates an assortment of enemies for the player to fight.
                        ]]

                        -- instantiate snail, declaring in advance so we can pass it into state machine
                        local snail
                        snail = Animal {
                            texture = 'creatures',
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 2) * TILE_SIZE + 2,
                            width = 16,
                            height = 16,
                            animationMoving = Animation {
                                frames = {53, 54},
                                interval = 0.5
                            },
                            animationIdle = Animation {
                                frames = {55},
                                interval = 1
                            },
                            stateMachine = StateMachine {
                                ['idle'] = function() return AnimalIdleState(self.tileMap, self.player, snail) end,
                                ['moving'] = function() return AnimalMovingState(self.tileMap, self.player, snail) end,
                                ['chasing'] = function() return AnimalChasingState(self.tileMap, self.player, snail) end
                            }
                        }

                        snail:changeState('idle', {
                            wait = math.random(5)
                        })

                        table.insert(self.level.entities, snail)

                    end

                    if math.random(math.max(20 - self.player.levelnumber, 5)) == 1 then
                      -- instantiate snail, declaring in advance so we can pass it into state machine
                      local snapper
                      snapper = Animal {
                          texture = 'snapper',
                          x = (x - 1) * TILE_SIZE,
                          y = (y - 2) * TILE_SIZE + 2,
                          width = 16,
                          height = 16,
                          animationMoving = Animation {
                              frames = {25, 26, 27, 28, 29},
                              interval = 0.1
                          },
                          animationIdle = Animation {
                              frames = {25},
                              interval = 1
                          },
                          stateMachine = StateMachine {
                              ['idle'] = function() return AnimalIdleState(self.tileMap, self.player, snapper) end,
                              ['moving'] = function() return AnimalMovingState(self.tileMap, self.player, snapper) end,
                              ['chasing'] = function() return AnimalChasingState(self.tileMap, self.player, snapper) end
                          }
                      }
                      snapper:changeState('idle', {
                          wait = math.random(5)
                      })

                    table.insert(self.level.entities, snapper)


                    local bomb
                    bomb =
                          Bomb {
                              texture = 'coins-bombs',
                              x = (x - 1) * TILE_SIZE,
                              y = (y - 2) * TILE_SIZE + 2,
                              width = 16,
                              height = 16,
                              animationMoving = Animation {
                                  frames = {4, 5, 6},
                                  interval = .2
                              },
                              animationIdle = Animation {
                                  frames = {4},
                                  interval = 1
                              },
                              stateMachine = StateMachine {
                                  ['idle'] = function() return BombIdleState(self.tileMap, self.player, bomb) end,
                                  ['trigger'] = function() return BombTriggeredState(self.tileMap, self.player, bomb) end
                              }
                          }

                          bomb:changeState('idle')

                      table.insert(self.level.entities, bomb)
                  end


                    if math.random(math.max(30 - self.player.levelnumber, 5)) == 1 then
                      -- instantiate snail, declaring in advance so we can pass it into state machine
                      local shark
                      shark = Animal {
                          texture = 'shark',
                          x = (x - 1) * TILE_SIZE,
                          y = (y - 2) * TILE_SIZE + 2,
                          width = 16,
                          height = 16,
                          animationMoving = Animation {
                              frames = {13, 14, 15, 16},
                              interval = 0.1
                          },
                          animationIdle = Animation {
                              frames = {13},
                              interval = .5
                          },
                          stateMachine = StateMachine {
                              ['idle'] = function() return AnimalIdleState(self.tileMap, self.player, shark) end,
                              ['moving'] = function() return AnimalMovingState(self.tileMap, self.player, shark) end,
                              ['chasing'] = function() return AnimalChasingState(self.tileMap, self.player, shark) end
                          }
                      }
                      shark:changeState('idle', {
                          wait = math.random(5)
                      })

                      table.insert(self.level.entities, shark)
                    end
                end
            end
        end
    end
end
