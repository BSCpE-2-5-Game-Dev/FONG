push = require 'push'
Class = require 'class'
require 'Paddle_1' -- Paddle
require 'Paddle_2' -- Paddle2
require 'Box'      -- ball

WIN_Width = 1024   -- 1280
WIN_Height = 600   -- 720
VIR_Width = 432    -- 423
VIR_Height = 243   -- 242
PAD_Speed = 275    -- 200

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fong')
    math.randomseed(os.time())

    s_Font = love.graphics.newFont('font.ttf', 8)
    L_Font = love.graphics.newFont('font.ttf', 16)
    SCORE _Font = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(s_Font)

    sounds = {
        ['paddleHit'] = love.audio.newSource('sounds/paddleHit.wav', 'static'),
        ['scoreHit'] = love.audio.newSource('sounds/scoreHit.wav', 'static'),
        ['wallHit'] = love.audio.newSource('sounds/wallHit.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static')
    }

    push:setupScreen(VIR_Width, VIR_Height, WIN_Width, WIN_Height, {
        fullscrn = false,
        resizable = true,
        V_sync = true, -- vsync
        canvas = false
    })

    Player_1_Score = 0
    Player_2_Score = 0
    Player_Server = 1
    Player_Winner = 0
    Player_1 = Paddle_1(10, VIR_Height / 2 - 12, 10, 24)
    Player_2 = Paddle_2(VIR_Width - 20, VIR_Height / 2 - 12, 10, 24)
    Fong_Ball = Box(VIR_Width / 2 - 5, VIR_Height / 2 - 5, 10, 10)
    Game_State = 'start'

end

function love.resize(w, h)

    push:resize(w, h)

end

function love.update(dt)

    if Game_State == 'serve' then
        Fong_Ball.dy = math.random(-50, 50)
        if Player_Server == 1 then
            Fong_Ball.dx = math.random(140, 200)
        else
            Fong_Ball.dx = -math.random(140, 200)
        end

    elseif Game_State == 'play' then
        if Fong_Ball:collides(Player_1) then
            Fong_Ball.dx = -Fong_Ball.dx * 1.07 -- 1.03
            Fong_Ball.x = Player_1.x + 10 -- 5

            if Fong_Ball.dy < 0 then
                Fong_Ball.dy = -math.random(10, 150)
            else
                Fong_Ball.dy = math.random(10, 150)
            end
            sounds['paddleHit']:play()
        end

        if Fong_Ball:collides(Player_2) then
            Fong_Ball.dx = -Fong_Ball.dx * 1.07 -- 1.03
            Fong_Ball.x = Player_2.x - 10 -- 4

            if Fong_Ball.dy < 0 then
                Fong_Ball.dy = -math.random(10, 150)
            else
                Fong_Ball.dy = math.random(10, 150)
            end
            sounds['paddleHit']:play()
        end

        if Fong_Ball.y <= 0 then
            Fong_Ball.y = 0
            Fong_Ball.dy = -Fong_Ball.dy
            sounds['wallHit']:play()
        end

        if Fong_Ball.y >= VIR_Height - 4 then
            Fong_Ball.y = VIR_Height - 4
            Fong_Ball.dy = -Fong_Ball.dy
            sounds['wallHit']:play()
        end
        
        if Fong_Ball.x < 0 then
            Player_Server = 1
            Player_2_Score = Player_2_Score + 1
            sounds['scoreHit']:play()

            if Player_2_Score == 10 then
                winningPlayer = 2
                Game_State = 'done'
                sounds['victory']:play()
            else
                Game_State = 'serve'
                Fong_Ball:reset()
            end
        end

        if Fong_Ball.x > VIR_Width then
            Player_Server = 2
            Player_1_Score = Player_1_Score + 1
            sounds['scoreHit']:play()
            
            if Player_1_Score == 10 then
                winningPlayer = 1
                Game_State = 'done'
                sounds['victory']:play()
            else
                Game_State = 'serve'
                Fong_Ball:reset()
            end
        end

    end

    if love.keyboard.isDown('w') then
        Player_1.dy = -PAD_Speed
    elseif love.keyboard.isDown('s') then
        Player_1.dy = PAD_Speed
    else
        Player_1.dy = 0
    end

    if love.keyboard.isDown('up') then
        Player_2.dy = -PAD_Speed
    elseif love.keyboard.isDown('down') then
        Player_2.dy = PAD_Speed
    else
        Player_2.dy = 0
    end

    if Game_State == 'play' then
        Fong_Ball:update(dt)
    end

    Player_1:update(dt)
    Player_2:update(dt)

end


function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
        if Game_State == 'start' then
            Game_State = 'serve'
        elseif Game_State == 'serve' then
            Game_State = 'play'
        elseif Game_State == 'done' then
            Game_State = 'serve'

            Fong_Ball:reset()

            Player_1_Score = 0
            Player_2_Score = 0

            if Player_Winner == 1 then -- winningPlayer
                Player_Server = 2
            else
                Player_Server = 1
            end
        end
    end

end

function love.draw()

    push:start() -- push:apply('start')
    Background:render() -- love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    love.graphics.setFont(s_Font)

    displayScore()

    if Game_State == 'start' then
        love.graphics.setFont(s_Font)
        love.graphics.printf('Welcome to Fong!', 0, 10, VIR_Width, 'center')
        love.graphics.printf('Press ENTER to begin!', 0, 20, VIR_Width, 'center')
    elseif Game_State == 'serve' then
        love.graphics.setFont(s_Font)
        love.graphics.printf('Player ' .. tostring(Player_Server) .. "'s serve!", 
            0, 10, VIR_Width, 'center')
        love.graphics.printf('Press ENTER to serve!', 0, 20, VIR_Width, 'center')
    elseif Game_State == 'play' then
    elseif Game_State == 'done' then
        love.graphics.setFont(L_Font)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIR_Width, 'center')
        love.graphics.setFont(s_Font)
        love.graphics.printf('Press ENTER to restart!', 0, 30, VIR_Width, 'center')
    end

    Player_1:render()
    Player_2:render()
    Fong_Ball:render()

    displayFPS()

    push:finish() -- push:apply('end')

end


function displayFPS()

    love.graphics.setFont(s_Font)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), VIR_Width - 40, 10)
    -- love.graphics.setColor(255/255, 255/244, 255/255, 255/255)
end

function displayScore()

    love.graphics.setFont(SCORE_Font)
    love.graphics.print(tostring(Player_1_Score), VIR_Width / 2 - 50, 
        VIR_Height - 43)
    love.graphics.print(tostring(Player_2_Score), VIR_Width / 2 + 30,
        VIR_Height - 43)

end
