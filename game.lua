
--scenes
require("scenes.intro")

function GameLoad()
    Resources:NewImage("assets/graphics/referencia1.png", "referencia1")
    Resources:NewSound("assets/sound/sfx_die.wav", "die", "static")

    print(Resources:ListAssets())

    SceneSystem:SetScene(IntroScene)
end

function GameDraw()
    
end

function GameUpdate(dt)
    
end