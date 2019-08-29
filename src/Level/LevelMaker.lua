--[[
    GD50
    Final Project

    -- LevelMaker Class --

]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}
    local widthlevel = width
    local heightlevel = height

    local tileID = TILE_ID_GROUND

    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)
    local keyflag = false
    local keygrabbed = false
    local treasureflag = false
    local pillarspawned = false

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY

        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness, make sure the first 2 aren't empty
        -- so our character will always spawn on ground
        if math.random(7) == 1 and x ~= 1 and x ~= 0 and x ~= 2
        and  x ~= (widthlevel/ 2) and x ~= (widthlevel - 5) then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(5) == 1 and x <= (widthlevel - 5) then
                blockHeight = 1.4

                if not keyflag then
                  table.insert(objects,

                      -- generate key
                      GameObject {
                          texture = 'keys',
                          x = (widthlevel/ 2) * TILE_SIZE,
                          y = (4 - 2) * TILE_SIZE,
                          width = 16,
                          height = 16,

                          -- make it a random variant of key
                          frame = math.random(1,4),
                          collidable = true,
                          consumable = true,
                          hit = false,
                          solid = false,

                          -- has its own function when consumed
                          onConsume = function(player, object)
                              gSounds['pickup']:play()
                              keygrabbed = true
                          end
                      }
                  )
                  keyflag = true
                end

                -- chance to generate coral on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'coral',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,

                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = 1,
                            collidable = false
                        }
                    )
                end

                if math.random(20) == 1 and x <= (widthlevel - 5) then
                  table.insert(objects,
                      GameObject {
                          texture = 'starfish',
                          x = (x - 1) * TILE_SIZE,
                          y = (4 - 1) * TILE_SIZE,
                          width = 16,
                          height = 16,

                          -- select random frame from bush_ids whitelist, then random row for variance
                          frame = 1,
                          collidable = true,
                          consumable = true,

                          onConsume = function(player, object)
                            gSounds['pickup']:play()
                            player:changeState('running')
                          end
                      }
                  )
                end

                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil

                pillarspawned = true

            -- chance to generate corals or keys (one key)
          elseif math.random(10) == 1 then
            pillarspawned = false

            -- spawn a treasure chest at the end
              if not treasureflag then
                table.insert(objects,

                    -- treasure
                      GameObject {
                        texture = 'treasure',
                        x = (widthlevel - 5) * TILE_SIZE,
                        y = (1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = 17,
                        collidable = true,
                        consumable = true,
                        solid = true,

                        onCollide = function(obj)

                            -- spawn a new treaure frame if we haven't already hit the treasure
                            if not obj.hit then
                              -- Only if player has the key
                              if keygrabbed == true then

                                    -- create treasure game object
                                    local treasureopen = GameObject {
                                        texture = 'treasure',
                                        x = (widthlevel - 3) * TILE_SIZE,
                                        y = (6 - 1-.25) * TILE_SIZE,
                                        width = 16,
                                        height = 16,
                                        frame = 5,
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- treasure has its own function
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 300

                                            if player.health < 5 then
                                              player.health = player.health + 2
                                            elseif player.health == 5 then
                                              player.health = player.health + 1
                                            end
                                            -- pass in score and longer level to play state
                                            gStateMachine:change('play',{
                                              score = player.score,
                                              levelnumber = player.levelnumber + 1,
                                              health = player.health

                                            })
                                        end
                                    }

                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, treasureopen)

                                    obj.hit = true
                                    obj.opacity = 0
                                  end
                            end
                        end
                    }
              )
                treasureflag = true
            end

            if not keyflag then
                table.insert(objects,

                    -- generate key
                    GameObject {
                        texture = 'keys',
                        x = (widthlevel/ 2) * TILE_SIZE,
                        y = (blockHeight - 2) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant of key
                        frame = math.random(1,4),
                        collidable = true,
                        consumable = true,
                        hit = false,
                        solid = false,

                        -- has its own function when consumed
                        onConsume = function(player, object)
                            gSounds['pickup']:play()
                            keygrabbed = true
                        end
                    }
                )
                keyflag = true
              end

              table.insert(objects,
                  GameObject {
                      texture = 'coral',
                      x = (x - 1) * TILE_SIZE,
                      y = (6 - 1) * TILE_SIZE,
                      width = 16,
                      height = 16,
                      frame = 1,
                      collidable = false
                  }
              )


            if math.random(13) == 1 and x ~= (widthlevel - 5) * TILE_SIZE then
              table.insert(objects,
                  GameObject {
                      texture = 'starfish',
                      x = (x - 1) * TILE_SIZE,
                      y = (6 - 1) * TILE_SIZE,
                      width = 16,
                      height = 16,

                      -- select random frame from bush_ids whitelist, then random row for variance
                      frame = 1,
                      collidable = true,
                      consumable = true,

                      onConsume = function(player, object)
                        gSounds['pickup']:play()
                        player:changeState('running')
                      end
                  }
                )
              end
            end

          -- chance to spawn a crate
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump crate
                    GameObject {
                        texture = 'crates-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#CRATES),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a coin if we haven't already hit the crate
                            if not obj.hit then

                                -- chance to spawn coin or heart, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    if math.random(2) == 1 then
                                      local coin = GameObject {
                                          texture = 'gold',
                                          x = (x - 1) * TILE_SIZE,
                                          y = (blockHeight - 2) * TILE_SIZE - 4,
                                          width = 16,
                                          height = 16,
                                          frame = 1,
                                          collidable = true,
                                          consumable = true,
                                          solid = false,

                                          -- coin has its own function to add to the player's score
                                          onConsume = function(player, object)
                                              gSounds['pickup']:play()
                                              player.score = player.score + 100
                                          end
                                      }

                                      -- make the coin move up from the crate and play a sound
                                      Timer.tween(0.1, {
                                          [coin] = {y = (blockHeight - 2) * TILE_SIZE}
                                      })
                                      gSounds['powerup-reveal']:play()

                                      table.insert(objects, coin)
                                  else
                                    local heart = GameObject {
                                        texture = 'hearts',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = 5,
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- heart has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()

                                            if player.health < 5 then
                                              player.health = player.health + 2
                                            elseif player.health == 5 then
                                              player.health = player.health + 1
                                            end

                                        end
                                    }

                                    -- make the coin move up from the crate and play a sound
                                    Timer.tween(0.1, {
                                        [heart] = {y = (blockHeight - 2.3) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, heart)
                                  end
                              end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles

    return GameLevel(entities, objects, map)
end
