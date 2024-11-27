require "classes.player"

Level = class("Level", Scene)

function Level:initialize()
    Scene:initialize(self)
    self.name = "Level"

    self.player = self:Instance(Player)
end

function Level:DestroyScene()
    print("Level destroyed")
end

function Level:draw()
    self.player:draw()
end

function Level:Update(dt)
    
end