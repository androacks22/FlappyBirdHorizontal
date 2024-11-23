require("systems.collision.collider")

RectCollider = class("RectCollider", Collider)

function RectCollider:initialize(x, y, width, height)
    Collider.initialize(self, x, y)
    self.type = "rect"
    self.width = width
    self.height = height

    print("nuevo rectCollider")
    
    CollisionManager:addCollider(self)
end

function RectCollider:setPosition(x, y)
    Collider.setPosition(self, x, y)
end

function RectCollider:destroy()
    CollisionManager:removeCollider(self)
end

function RectCollider:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end