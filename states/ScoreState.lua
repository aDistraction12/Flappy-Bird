ScoreState = Class{__includes = BaseState}

local score3 = love.graphics.newImage('sprites/medal5.png')
local score5 = love.graphics.newImage('sprites/medal8.png')
local score10 = love.graphics.newImage('sprites/medal12.png')

local Medal = score3
local pipesPassed = 0

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    noMedal = false
    pipesPassed = 0
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
    if self.score >= 10 then
    
        Medal = score10
    
    elseif self.score >= 5 then
        
        Medal = score5
 
    elseif self.score >= 3 then
        
        Medal = score3

    else
        noMedal = true
    end
   
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Congrats ! Your Score is : ' .. tostring(self.score) , 0, 130, VIRTUAL_WIDTH, 'center')
    if noMedal then
        love.graphics.printf('Too Bad  You Need to Score More to Achieve a Medal' , 0, 160, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Congrats ! Your Score is : ' .. tostring(self.score) , 0, 130, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(Medal,VIRTUAL_WIDTH/2-(Medal:getWidth()/2),185-Medal:getHeight()/2)
    end 
    love.graphics.printf('Press Enter to Play Again!', 0, 220, VIRTUAL_WIDTH, 'center')

end