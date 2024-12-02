-- Importa las librerías de terceros
require("thirdparty.thirdparty")
require("systems.collision.collisionManager")
require("systems.scenes.sceneSystem")
require("systems.resourcesManager.resourcesManager")
require("game")
require("scenes.Level")

timer = 0;

function love.load()
    -- Configura Maid64
    maid.setup(600, 600, false)

    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Configura el sistema de colisiones
    CollisionManager:load()
    -- Configura el sistema de escenas
    SceneSystem:initialize()

    GameLoad()
end

function love.draw()
    maid.start()

    GameDraw()
    CollisionManager:draw()

    love.graphics.print("fps : " .. love.timer.getFPS())
    
    
    maid.finish()
end

function love.update(dt)
    -- Escala la posición del ratón antes de actualizar LoveFrames
    local scaledX, scaledY = maid.mouse.getX(), maid.mouse.getY()

    GameUpdate(dt)

    -- Actualiza el sistema de escenas y colisiones
    SceneSystem:update(dt)
    CollisionManager:update(dt)
end

function love.resize(w, h)
    maid.resize(w, h)
end

function love.mousepressed(x, y, button, isTouch)
    SceneSystem:mousepressed(x, y, button, isTouch)
end

function love.mousereleased(x , y, button, isTouch)
    SceneSystem:mousereleased(x, y, button, isTouch)
end

function printTable(t, indent)
    indent = indent or 0
    for key, value in pairs(t) do
        local prefix = string.rep("  ", indent)
        if type(value) == "table" then
            print(prefix .. key .. ":")
            printTable(value, indent + 1)
        else
            print(prefix .. key .. ": " .. tostring(value))
        end
    end
end