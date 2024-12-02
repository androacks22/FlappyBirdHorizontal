
--scenes
require("scenes.intro")

function GameLoad()

    SceneSystem:SetScene(IntroScene)
end

function GameDraw()
    SceneSystem:draw()
end

function GameUpdate(dt)
    SceneSystem:update(dt)
end