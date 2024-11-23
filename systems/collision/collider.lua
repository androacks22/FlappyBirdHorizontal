--abstract
Collider = class("Collider")

function Collider:initialize(x, y)
    self.type = "Null"
    self.x = x;
    self.y = y;
    self.isColliding = false -- Si está colisionando
    self.isEntered = false   -- Si acaba de empezar a colisionar
    self.isExit = false      -- Si acaba de dejar de colisionar
    self.collisionCount = 0   -- Contador de colisiones (con cuantos objetos está colisionando)
end

function Collider:setPosition(x, y)
    self.x = x
    self.y = y
end

function Collider:destroy()
    
end

function Collider:update(dt)
    
end