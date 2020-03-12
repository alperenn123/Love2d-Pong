WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

push = require 'push'
Class = require 'class'

require "Ball"
require "Paddle"

function love.load()
  love.graphics.setDefaultFilter('nearest','nearest')
      push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
      fullscreen = false,
      vsync = true,
      resizable = false
    })
  love.window.setTitle("Pong")
  math.randomseed(os.time())
  
  smallfont = love.graphics.newFont('font.ttf',8)
  
  score_font = love.graphics.newFont('font.ttf',16)
  
  love.graphics.setFont(smallfont)
  
  player1 = Paddle(10,30,5,20)
  player1_score = 0
  player2_score = 0
  servingPlayer = 1
  winningPlayer = 0
  player2 = Paddle(VIRTUAL_WIDTH - 10,VIRTUAL_HEIGHT - 30,5,20)
  
  ball = Ball(VIRTUAL_WIDTH / 2 - 2,VIRTUAL_HEIGHT/2 - 2,4,4)
  
  gamestate = 'start'
end

function love.draw()
  push:apply('start')

  love.graphics.clear(40/255,45/255,52/255,1)
  love.graphics.printf('HELLO PONG!',0,VIRTUAL_HEIGHT/ 2 - 100,VIRTUAL_WIDTH,'center')
  love.graphics.printf('PLEASE PRESS ENTER FOR START!',0,VIRTUAL_HEIGHT/ 2 - 80,VIRTUAL_WIDTH,'center')
  love.graphics.setFont(score_font)
  love.graphics.print(tostring(player1_score),VIRTUAL_WIDTH / 2 - 50,VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(player2_score),VIRTUAL_WIDTH / 2 + 30,VIRTUAL_HEIGHT / 3)
    
  player1:render()
  
  player2:render()
  
  ball:render()
  display_fps()
  push:apply('end')
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gamestate == 'start' then
      gamestate = 'serve'
    elseif gamestate == 'serve' then
      gamestate = 'play'
    elseif gamestate == 'done' then
      gamestate = 'serve'
      ball:reset()
      player1_score = 0
      player2_score = 0
      
      if winningPlayer == 1 then
        servingPlayer = 2
      else
        servingPlayer = 1
      end
    end
  end
    

end

function love.update(dt)
  if gamestate == "serve" then
    ball.dy = math.random(-50,50)
    if servingPlayer == 1 then
      ball.dx = -math.random(140,200)
    else
      ball.dx = math.random(140,200)
    end
  elseif gamestate == "play" then
    if love.keyboard.isDown('w') then
      player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
      player1.dy = PADDLE_SPEED
    else
      player1.dy = 0
    end
  
  if love.keyboard.isDown('up') then
      player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
      player2.dy = PADDLE_SPEED
    else
      player2.dy = 0
  end
    
    if ball:collides(player1) then
      ball.dx = -ball.dx * 1.03
      ball.x = player1.x + ball.width
      if ball.dy < 0 then
        ball.dy = -math.random(10,150)
      else
        ball.dy = math.random(10,150)
      end
    end
    if ball:collides(player2) then
    ball.dx = -ball.dx * 1.03
    ball.x = player2.x - ball.width
     if ball.dy < 0 then
        ball.dy = -math.random(10,150)
      else
        ball.dy = math.random(10,150)
      end
    end
    if ball.y >= VIRTUAL_HEIGHT - 4 then
      ball.y = VIRTUAL_HEIGHT -4
      ball.dy = -ball.dy
    end
    if ball.y <= 0 then
      ball.y = 0
      ball.dy = -ball.dy
    end
    if ball.x < 0 then
      player2_score = player2_score + 1
      ball:reset()
      servingPlayer = 2
      if player2_score == 10 then
        winningPlayer = 2
        gamestate = 'done'
      else
        gamestate = 'serve'
        ball:reset()
      end
    end
    
    if ball.x > VIRTUAL_WIDTH then
      player1_score = player1_score + 1
      ball:reset()
      servingPlayer = 1
      if player1_score == 10 then
        winningPlayer = 1
        gamestate = 'done'
      else
        gamestate = 'serve'
        ball:reset()
      end
    end
      
    ball:update(dt)
    player1:update(dt)
    player2:update(dt)
  end
end


function display_fps()
  love.graphics.setFont(smallfont)
  love.graphics.setColor(0,1,0,1)
  love.graphics.print('FPS:' .. tostring(love.timer.getFPS()),10,10)
end