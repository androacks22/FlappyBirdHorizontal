-- Importa las librerías de terceros
require("thirdparty.thirdparty")
require("systems.collision.collisionManager")
require("systems.scenes.sceneSystem")
require("scenes.Level")

timer = 0;

function love.load()
    --Configura Maid64
    maid.setup(600, 600, false)

    --Configura el sistema de colisiones
    CollisionManager:load()
    --Configura el sistema de escenas
    SceneSystem:initialize()

    SceneSystem:SetScene(Level)
end

function love.update(dt)
    --Escala la posición del ratón antes de actualizar LoveFrames
    local scaledX, scaledY = maid.mouse.getX(), maid.mouse.getY()

    if(timer > 6 ) then
        SceneSystem:SetScene(Level)
        timer = 0;
    end

    --Actualiza el sistema de escenas y colisiones
    SceneSystem:update(dt)
    CollisionManager:update(dt)

    timer = timer + 1 * dt;
end

function love.draw()
    maid.start()

    SceneSystem:draw()
    CollisionManager:draw()

    love.graphics.print("timer : " .. timer)

    maid.finish()
end

function love.resize(w, h)
    maid.resize(w, h)
end