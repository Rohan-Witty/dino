-- virtual resolution handling library
push = require 'push'
-- Std library
Class = require 'class'
-- Our class
require 'Dino'

-- tree class we've written
require 'Tree'


-- all code related to game state and state machines
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/PauseState'
require 'states/ScoreState'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- images we load into memory from files to later draw onto the screen
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 60
GROUND_SCROLL_SPEED = 120

local BACKGROUND_LOOPING_POINT = 413

--SCROLL_ACCELERATION = 6

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Dino')


    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('ostrich-regular.ttf', 8)
    mediumFont = love.graphics.newFont('Pacifico.ttf', 14)
    hugeFont = love.graphics.newFont('PlayfairDisplaySC-Regular.otf', 28)
    love.graphics.setFont(mediumFont)

    sounds = {
        ['jump'] = love.audio.newSource('Jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('Explosion.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),

        ['music'] = love.audio.newSource('background.mp3', 'static')
    }
    
    -- kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()


    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })


    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['pause'] = function() return PauseState() end,
        ['score'] = function() return ScoreState() end,
     }
    gStateMachine:change('title')


    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    New function used to check our global input table for keys we activated during
    this frame, looked up by their string value.
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    -- scroll background by preset speed * dt, looping back to 0 after the looping point
    --BACKGROUND_SCROLL_SPEED = 60 + SCROLL_ACCELERATION*(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

    -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
    --GROUND_SCROLL_SPEED = 120 + SCROLL_ACCELERATION*(dt)
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % VIRTUAL_WIDTH

        -- now, we just update the state machine, which defers to the right state
    gStateMachine:update(dt)    

    
    -- reset input table    
    love.keyboard.keysPressed = {}
    
end

function love.draw()
    push:start()
    
    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, -backgroundScroll, 0)


    gStateMachine:render()

    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    push:finish()
end