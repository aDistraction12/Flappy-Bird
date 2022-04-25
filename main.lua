push = require 'libraries/push'

Class = require 'libraries/class'

require 'Classes/Bird'

require 'Classes/Pipe'

require 'Classes/PipePair'

require 'states/StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--Adding Background image and variable
local background = love.graphics.newImage('sprites/background.png')
local backgroundScroll = 0

--Adding the ground image and variable
local ground = love.graphics.newImage('sprites/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()

local pipePairs = {}

local spawnTimer = 0

local lastY = -PIPE_HEIGHT + math.random(80) + 20

scrolling = true

--setting the required parameters for game
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Flappy Bird')

    --Settings up new fonts for Title screens
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('audio/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('audio/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('audio/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('audio/score.wav', 'static'),
        ['pause'] = love.audio.newSource('audio/pause.wav', 'static'),
        ['music'] = love.audio.newSource('audio/marios_way.mp3', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT , {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    --initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['countdown'] = function() return CountdownState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    --initialize input table
    love.keyboard.keysPressed = {}
end

--Function for resizing the window
function love.resize(w, h)
    push:resize(w, h)
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

--Function for quitting the game
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end

    if  key == 'p' then
        sounds['pause']:play()

        if paused then
        sounds['music']:play()
        paused = false
        else 
            sounds['music']:pause()
            x=1
        end
    end
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

--Function for checking the key pressed on each frame
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end


--Updating background and ground to generate scroll effect
function love.update(dt)
     if x == 1 then
        paused = true
        x = o 
    end

    if not paused then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
            % BACKGROUND_LOOPING_POINT

        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
            % VIRTUAL_WIDTH

        gStateMachine:update(dt)
        --Flushing the key pressed value to track it again
        love.keyboard.keysPressed = {}
        love.mouse.buttonsPressed = {}
    end       
end

--Function for rendering things on screen
function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)
    
    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    if paused then
        love.graphics.setColor(0,0,0,90/255)
        love.graphics.rectangle('fill', 0, 0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
        love.graphics.setFont(hugeFont)
        love.graphics.printf('PAUSE',0,100,VIRTUAL_WIDTH,'center')
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Press ESC to Exit',0,170,VIRTUAL_WIDTH,'center')

    end
    push:finish()
end