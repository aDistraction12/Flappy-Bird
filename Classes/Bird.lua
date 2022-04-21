Bird = Class{}

local GRAVITY = 20

--initilizing the bird
function Bird:init()
    self.image = love.graphics.newImage('sprites/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

--Updating the bird on each frame
--adding the antiGravity effect
function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = -5
    end

    self.y = self.y + self.dy
end

--Rendering the bird
function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

