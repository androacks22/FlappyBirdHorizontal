require "systems.collision.rectCollider"

CollisionManager = {}

function CollisionManager:load()
    self.colliders = {}
end

function CollisionManager:addCollider(collider)
    table.insert(self.colliders, collider)
end

function CollisionManager:removeCollider(collider)
    for i, col in ipairs(self.colliders) do
        if col == collider then
            table.remove(self.colliders, i)
            break
        end
    end
end

--Función para verificar colisiones entre dos colisionadores rectangulares (AABB)
function CollisionManager:checkCollision(collider1, collider2)
    --Asegurar de que ambos colisionadores sean rectangulares
    if not collider1 or not collider2 then return false end
    if collider1.type ~= "rect" or collider2.type ~= "rect" then return false end
    
    --AABB (Axis-Aligned Bounding Box) check
    return not (collider1.x + collider1.width < collider2.x or  --collider1 está a la izquierda de collider2
                collider1.x > collider2.x + collider2.width or  --collider1 está a la derecha de collider2
                collider1.y + collider1.height < collider2.y or --collider1 está por encima de collider2
                collider1.y > collider2.y + collider2.height)   --collider1 está por debajo de collider2
end

--Función para actualizar todas las colisiones
function CollisionManager:update(dt)
    --Recorre los colisionadores y actualiza el estado de colisión
    for i = 1, #self.colliders do
        local collider1 = self.colliders[i]
        
        --Almacena el estado anterior de la colisión
        local wasColliding = collider1.isColliding
        collider1.collisionCount = 0 --Reseteamos el contador de colisiones
        
        --Verifica si está colisionando con algún otro colisionador
        collider1.isColliding = false
        for j = 1, #self.colliders do
            if i ~= j then
                local collider2 = self.colliders[j]
                if self:checkCollision(collider1, collider2) then
                    collider1.isColliding = true
                    collider1.collisionCount = collider1.collisionCount + 1
                    --break
                end
            end
        end
        
        --Si la colisión acaba de empezar
        if collider1.isColliding and not wasColliding then
            collider1.isEntered = true
        else
            collider1.isEntered = false
        end
        
        --Si la colisión acaba de terminar
        if not collider1.isColliding and wasColliding then
            collider1.isExit = true
        else
            collider1.isExit = false
        end
    end
end

function CollisionManager:draw()
    for _, collider in ipairs(self.colliders) do
        if collider.draw then
            collider:draw()
        end
    end
end
