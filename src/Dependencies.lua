--
-- libraries
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/GameObject'
require 'src/Player'
require 'src/StateMachine'
require 'src/Util'
require 'src/Tile'
require 'src/TileMap'
require 'src/Animal'
require 'src/bomb'

require 'src/Level/LevelMaker'
require 'src/Level/GameLevel'

require 'src/states/BaseState'

require 'src/states/entity/AnimalIdleState'
require 'src/states/entity/AnimalMovingState'
require 'src/states/entity/AnimalChasingState'
require 'src/states/entity/BombIdleState'
require 'src/states/entity/BombTriggeredState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerWalkingState'
require 'src/states/entity/player/PlayerJumpState'
require 'src/states/entity/player/PlayerFallingState'
require 'src/states/entity/player/PlayerRunningState'

require 'src/states/game/GameOverState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'

gSounds = {
    ['jump'] = love.audio.newSource('sounds/jump.wav'),
    ['death'] = love.audio.newSource('sounds/death.wav'),
    ['music-play1'] = love.audio.newSource('sounds/Blackmoor.wav'),
    ['music-play2'] = love.audio.newSource('sounds/ThemeofAgrual.mp3'),
    ['music-play3'] = love.audio.newSource('sounds/underwater.ogg'),
    ['music-game-over'] = love.audio.newSource('sounds/Beach_01.ogg'),
    ['powerup-reveal'] = love.audio.newSource('sounds/powerup-reveal.wav'),
    ['pickup'] = love.audio.newSource('sounds/pickup.wav'),
    ['empty-block'] = love.audio.newSource('sounds/empty-block.wav'),
    ['kill'] = love.audio.newSource('sounds/kill.wav'),
    ['kill2'] = love.audio.newSource('sounds/kill2.wav'),
    ['sword'] = love.audio.newSource('sounds/sword.wav'),
    ['hit-enemy'] = love.audio.newSource('sounds/hit_enemy.wav'),
    ['hit-player'] = love.audio.newSource('sounds/hit_player.wav'),
    ['running'] = love.audio.newSource('sounds/running.wav'),
    ['explosion'] = love.audio.newSource('sounds/explosion.mp3')
}

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
    ['toppers'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['crates-blocks'] = love.graphics.newImage('graphics/crates_and_blocks.png'),
    ['gold'] = love.graphics.newImage('graphics/gold.png'),
    ['keys'] = love.graphics.newImage('graphics/keys_and_locks.png'),
    ['green-alien'] = love.graphics.newImage('graphics/green_alien.png'),
    ['creatures'] = love.graphics.newImage('graphics/creatures.png'),
    ['starfish'] = love.graphics.newImage('graphics/red-starfish-eyes.png'),
    ['coins-bombs'] = love.graphics.newImage('graphics/coins_and_bombs.png'),
    ['fireballs'] = love.graphics.newImage('graphics/fireballs.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['shark'] = love.graphics.newImage('graphics/sharks.png'),
    ['snapper'] = love.graphics.newImage('graphics/scaryfish.png'),
    ['treasure'] = love.graphics.newImage('graphics/chest_mimic.png'),
    ['backgrounds'] = love.graphics.newImage('graphics/background.png'),
    ['coral'] =  love.graphics.newImage('graphics/pink-anem.png'),
    ['pirate'] =  love.graphics.newImage('graphics/captain.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['toppers'] = GenerateQuads(gTextures['toppers'], 16, 16),
    ['crates-blocks'] = GenerateQuads(gTextures['crates-blocks'], 16, 16),
    ['gold'] = GenerateQuads(gTextures['gold'], 16, 16),
    ['backgrounds'] = GenerateQuads(gTextures['backgrounds'], 270, 195),
    ['green-alien'] = GenerateQuads(gTextures['green-alien'], 16, 20),
    ['creatures'] = GenerateQuads(gTextures['creatures'], 16, 16),
    ['keys'] = GenerateQuads(gTextures['keys'], 16, 16),
    ['starfish'] = GenerateQuads(gTextures['starfish'], 16, 16),
    ['coins-bombs'] = GenerateQuads(gTextures['coins-bombs'], 16, 16),
    ['fireballs'] = GenerateQuads(gTextures['fireballs'], 16, 16),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 16, 16),
    ['shark'] = GenerateQuads(gTextures['shark'], 16, 16),
    ['snapper'] = GenerateQuads(gTextures['snapper'], 17, 15),
    ['treasure'] = GenerateQuads(gTextures['treasure'], 16, 20),
    ['coral'] = GenerateQuads(gTextures['coral'], 16, 16),
    ['pirate'] = GenerateQuads(gTextures['pirate'], 24, 18)

}

-- these need to be added after gFrames is initialized because they refer to gFrames from within
gFrames['tilesets'] = GenerateTileSets(gFrames['tiles'],
    TILE_SETS_WIDE, TILE_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

gFrames['toppersets'] = GenerateTileSets(gFrames['toppers'],
    TOPPER_SETS_WIDE, TOPPER_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
}
