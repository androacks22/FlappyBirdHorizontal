-- Importa las librerías de terceros
require("thirdparty.thirdparty")
require("systems.collision.collisionManager")

function love.load()
    -- Configura Maid64
    maid.setup(600, 600, false)

    --configura el sistema de colisiones
    CollisionManager:load()
end

function love.draw()
    maid.start()

    CollisionManager:draw()

    maid.finish()
end

function love.update(dt)
    -- Escala la posición del ratón antes de actualizar LoveFrames
    local scaledX, scaledY = maid.mouse.getX(), maid.mouse.getY()

    CollisionManager:update(dt);
end

function love.resize(w, h)
    maid.resize(w, h)
end

function love.mousepressed(_, __, button)
    -- Escalar las coordenadas del ratón
    local scaledX, scaledY = maid.mouse.getX(), maid.mouse.getY()
end

function love.mousereleased(_, __, button)
    -- Escalar las coordenadas del ratón
    local scaledX, scaledY = maid.mouse.getX(), maid.mouse.getY()
end

function love.wheelmoved(x, y)

end

function love.keypressed(key, isrepeat)
    
end

function love.keyreleased(key)
    
end

function love.textinput(text)

end
