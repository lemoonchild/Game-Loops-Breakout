-- Breakout

local WINDOW_WIDTH = 800
local WINDOW_HEIGHT = 600
local PADDLE_SPEED = 400 -- píxeles por segundo
local BALL_SPEED = 250 -- píxeles por segundo
local BALL_SPEEDUP = 1.05 -- multiplicador de velocidad al pegarle a la paddle

local BRICK_ROWS = 5
local BRICK_COLS = 9
local BRICK_WIDTH = 80
local BRICK_HEIGHT = 25
local BRICK_PADDING = 8 -- espacio entre bloques
local BRICK_TOP_OFFSET = 50 -- separación desde el borde superior

local BRICK_COLORS = {
    {0.05, 0.1,  0.35}, 
    {0.1,  0.2,  0.5},  
    {0.15, 0.35, 0.7},  
    {0.3,  0.55, 0.85}, 
    {0.55, 0.75, 0.95}, 
}

local BALL_COLOR = {0.6, 0.2, 0.8} -- morado

local paddle
local ball
local bricks

-- Detección de colisión entre dos rectángulos (AABB).
-- Dos rectángulos NO se tocan si uno está completamente a la izquierda,
-- derecha, arriba o abajo del otro. Si ninguna de esas 4 condiciones se
-- cumple, están superpuestos (chocan).
local function checkCollision(a, b)
    return a.x < b.x + b.width
       and a.x + a.width > b.x
       and a.y < b.y + b.height
       and a.y + a.height > b.y
end

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle("Breakout")

    paddle = {
        x = 350,
        y = 560,
        width = 100,
        height = 15,
    }

    ball = {
        x = 395,
        y = 300,
        width = 12,
        height = 12,
        dx = 1,   -- dirección horizontal: 1 = derecha, -1 = izquierda
        dy = -1,  -- dirección vertical: -1 = arriba, 1 = abajo
        speed = BALL_SPEED,
    }

    -- bricks empieza como lista vacía, y se llena con un doble for:
    -- una fila (row) por cada fila, y dentro, una columna (col) por bloque.
    bricks = {}
    for row = 0, BRICK_ROWS - 1 do
        for col = 0, BRICK_COLS - 1 do
            table.insert(bricks, {
                x = col * (BRICK_WIDTH + BRICK_PADDING) + BRICK_PADDING,
                y = row * (BRICK_HEIGHT + BRICK_PADDING) + BRICK_TOP_OFFSET,
                width = BRICK_WIDTH,
                height = BRICK_HEIGHT,
                color = BRICK_COLORS[row + 1], -- +1 porque row arranca en 0 y Lua indexa desde 1
            })
        end
    end
end

function love.update(dt)
    if love.keyboard.isDown("left") then
        paddle.x = paddle.x - PADDLE_SPEED * dt
    elseif love.keyboard.isDown("right") then
        paddle.x = paddle.x + PADDLE_SPEED * dt
    end

    paddle.x = math.max(0, math.min(paddle.x, WINDOW_WIDTH - paddle.width))

    ball.x = ball.x + ball.dx * ball.speed * dt
    ball.y = ball.y + ball.dy * ball.speed * dt

    -- Pared izquierda
    if ball.x <= 0 then
        ball.x = 0
        ball.dx = -ball.dx
    end

    -- Pared derecha
    if ball.x + ball.width >= WINDOW_WIDTH then
        ball.x = WINDOW_WIDTH - ball.width
        ball.dx = -ball.dx
    end

    -- Pared de arriba
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
    end

    -- Colisión con la paddle
    if checkCollision(ball, paddle) then
        ball.y = paddle.y - ball.height -- sacarla de encima de la paddle
        ball.dy = -ball.dy
        ball.speed = ball.speed * BALL_SPEEDUP
    end

    -- Colisión con bloques
    for i, brick in ipairs(bricks) do
        if checkCollision(ball, brick) then
            table.remove(bricks, i)
            ball.dy = -ball.dy
            break -- cortamos el loop: ya resolvimos el choque de este frame
        end
    end

    -- Si no queda ningún bloque, ganaste
    if #bricks == 0 then
        print("You Win!")
        love.event.quit()
    end

    -- Pared de abajo, fin del juego
    if ball.y + ball.height >= WINDOW_HEIGHT then
        print("Game Over")
        love.event.quit()
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.width, paddle.height)

    love.graphics.setColor(BALL_COLOR[1], BALL_COLOR[2], BALL_COLOR[3])
    love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)

    for _, brick in ipairs(bricks) do
        love.graphics.setColor(brick.color[1], brick.color[2], brick.color[3])
        love.graphics.rectangle("fill", brick.x, brick.y, brick.width, brick.height)
    end
end
