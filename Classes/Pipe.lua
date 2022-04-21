Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('sprites/pipe.png')

PIPE_SPEED = 60

PIPE_HEIGHT = 288
PIPE_WIDTH = 70

--initializing the pipe 
function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

--Updating the pipe on each frame
function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

--Rendering the Pipe
function Pipe:render()
    --Code for fliping the pipe of the top
    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 0, 1, self.orientation =='top' and -1 or 1)
end
