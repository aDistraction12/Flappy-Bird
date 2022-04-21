push = require 'libraries/push'

Class = require 'libraries/class'

require 'Classes/Bird'

require 'Classes/Pipe'

require 'Classes/PipePair'

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

local scrolling = true

--setting the required parameters for game
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Flappy Bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT , {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}
end

--Function for resizing the window
function love.resize(w, h)
    push:resize(w, h)
end

--Function for quitting the game
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
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
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
            % BACKGROUND_LOOPING_POINT

        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
            % VIRTUAL_WIDTH

        --Spawning pipes after every 2 sec
        spawnTimer = spawnTimer + dt

        if spawnTimer > 2 then
            local y = math.max(-PIPE_HEIGHT + 10, math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            lastY = y

            table.insert(pipePairs, PipePair(y))
            spawnTimer = 0 
        end

        bird:update(dt)

        --removing pipes from the screen once they have passed 
        for k, pair in pairs(pipePairs) do
            pair:update(dt)
        end

        for l, pipe in pairs(pipePairs) do
            if bird:collides(pipe) then
                scrolling = false
            end
        end
        
        for k, pair in pairs(pipePairs) do
            if pair.remove then
                table.remove(pipePairs, k)
            end
        end

        --Flushing the key pressed value to track it again
    end        love.keyboard.keysPressed = {}
end

--Function for rendering things on screen
function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)

    for k, pair in pairs(pipePairs) do 
        pair:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    bird:render()
    push:finish()
end