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
    for i, v in ipairs(self.objects) do
        if v.draw then
            v:draw()
        end 
    end
end

function Level:update(dt)
    for i, v in ipairs(self.objects) do
        if v.update then
            v:update(dt)
        end
    end
end

function Level:mousepressed(x, y, button, isTouch)
    self.player:mousepressed(x, y, button)
end