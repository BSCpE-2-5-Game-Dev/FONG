--[[
    GD50 2018
    Pong Remake

    -- paddle Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a paddle that can move up and down. Used in the main
    program to deflect the ball back toward the opponent.
]]

paddle = Class{}

function paddle:init(x, y, width, height)

    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0

end

function paddle:update(dt)

    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    
    else    
        self.y = math.min(VIR_Height - self.height, self.y + self.dy * dt)
    end

end

function paddle:render()

    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

end