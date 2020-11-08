--[[
    GD50 2018
    Pong Remake

    -- ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.
]]

ball = Class{}

function ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(2) == 1 and math.random(-80, -100) or math.random(80, 100)
end

function ball:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end 

    return true
end

function ball:reset()
    self.x = VIR_Width / 2 - 2
    self.y = VIR_Height / 2 - 2
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
end

function ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end