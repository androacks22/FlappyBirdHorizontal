Player = class("Player")

function Player:initialize()
    self.position = {x=love.math.random(0, 600-32), y=love.math.random(0, 600-32)}
    self.sprite = Resources:LoadImage("referencia1")
    self.sfx = {["die"] = Resources:LoadSound("die")}

    love.audio.play(self.sfx["die"])
end

function Player:draw()
    love.graphics.draw(self.sprite, self.position.x, self.position.y)
end

function Player:update(dt)
    
end