Player = class("Player")

function Player:initialize()
    self.position = {x = love.math.random(0, 568), y = love.math.random(0, 568)} -- Ajuste para 32 de ancho/alto
    self.sprite = Resources:LoadImage("player")
    self.spriteMask = Resources:LoadImage("player_mask")
    self.color = {r = 1, g = 1, b = 0, a = 1}
    self.offset = {10, 9}

    --Animaciones
    self.quads = {
        Resources:LoadQuad("player_animations_1"),
        Resources:LoadQuad("player_animations_2"),
        Resources:LoadQuad("player_animations_3"),
    }
    self.quadIndex = 1
    self.animationSpeed, self.animationTime, self.isAnimating = 0.1, 0, false
    self.animationCycles = 0 --Contador de ciclos de animación

    --Sonidos
    self.sfx = {die = Resources:LoadSound("die")}
    love.audio.play(self.sfx.die)

    --Física
    self.velocityX, self.velocityY = 50, 0
    self.gravity, self.jumpForce = 200, -175
    self.maxVelocityY = 250

    self.hitBox = RectCollider(self.position.x, self.position.y, 18, 18)

    --Rotación
    self.angle, self.targetAngle, self.maxAngle = 0, 0, 45

    -- Dirección
    self.angleDirection = 1 -- 1: derecha, -1: izquierda
end

function Player:draw()
    local scaleX = 2 * self.angleDirection
    love.graphics.draw(self.sprite, self.quads[self.quadIndex], self.position.x + self.offset[1], self.position.y + self.offset[2], math.rad(self.angle), scaleX, 2, 14, 14)
    
    --Con esto dibujamos una "mascara", con el que se puede cambiar facilmente el color del pajaro mamón
    --Así se verá Di-vi-na
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    love.graphics.draw(self.spriteMask, self.quads[self.quadIndex], self.position.x + self.offset[1], self.position.y + self.offset[2], math.rad(self.angle), scaleX, 2, 14, 14)
    love.graphics.setColor(1, 1, 1, 1)
    --Debug
    --[[love.graphics.print(
        "Target angle : " .. self.targetAngle ..
        "\nAngle : " .. self.angle ..
        "\nSpeedY : " .. self.velocityY
        , 100, 100
    )]]
end

function Player:update(dt)
    --Movimiento horizontal
    self.position.x = self.position.x + self.velocityX * self.angleDirection * dt
    if self.position.x > 568 or self.position.x < 0 then
        self.angleDirection = -self.angleDirection
        self.position.x = math.clamp(self.position.x, 0, 568)
    end

    --Movimiento vertical
    self.velocityY = math.min(self.velocityY + self.gravity * dt, self.maxVelocityY)
    self.position.y = math.min(self.position.y + self.velocityY * dt, 568)
    
    if self.position.y >= 568 then
        self.velocityY, self.angle, self.isAnimating = 0, 0, false
        self.quadIndex, self.animationCycles = 1, 0
    end

    --Determinar el ángulo base (baseAngle) según la velocidad vertical
    --Si velocityY > 0 (el personaje está cayendo), el ángulo base será maxAngle (mirando hacia abajo).
    --Si velocityY < 0 (el personaje está subiendo), el ángulo base será -maxAngle (mirando hacia arriba).
    --Si velocityY == 0, el ángulo base será 0 (sin inclinación).
    local baseAngle = self.velocityY > 0 and self.maxAngle or (self.velocityY < 0 and -self.maxAngle or 0)

    --Ajustar el ángulo objetivo (targetAngle) según la dirección horizontal (angleDirection).
    --Si angleDirection es -1 (mirando a la izquierda), se invierte el ángulo base.
    --Esto se debe a que la imagen del personaje está reflejada horizontalmente,
    --lo que invierte el sentido de rotación del sprite, por lo que el ángulo también debe invertirse.
    if self.angleDirection == -1 then
        --Invertir el ángulo base cuando el personaje mira hacia la izquierda.
        self.targetAngle = -baseAngle
    else
        --Usar el ángulo base directamente cuando el personaje mira hacia la derecha.
        self.targetAngle = baseAngle
    end

    --Calcular la velocidad de rotación (rotationSpeed) en función de la magnitud de la velocidad vertical.
    --Queremos que la velocidad de rotación sea proporcional a la velocidad vertical, 
    --pero limitada entre 0 y un factor máximo (10 en este caso).
    --math.abs(self.velocityY): toma el valor absoluto de la velocidad vertical para trabajar con magnitudes positivas.
    --self.maxVelocityY: representa la velocidad vertical máxima permitida.
    --math.abs(self.velocityY) / self.maxVelocityY: obtiene un valor normalizado entre 0 y 1 según la velocidad actual.
    --math.min(..., 1): asegura que el valor no exceda 1.
    --* 10: escala el valor normalizado para definir la velocidad máxima de rotación.
    local rotationSpeed = math.min(math.abs(self.velocityY) / self.maxVelocityY, 1) * 10

    --Ajustar suavemente el ángulo actual (angle) hacia el ángulo objetivo (targetAngle).
    --(self.targetAngle - self.angle): calcula la diferencia entre el ángulo objetivo y el actual.
    --* dt: escala la diferencia por el tiempo delta para asegurar cambios suaves e independientes de la velocidad de fotogramas.
    --* rotationSpeed: multiplica por la velocidad de rotación calculada para que dependa de la magnitud de la velocidad vertical.
    --self.angle + ...: incrementa o decrementa el ángulo actual hacia el objetivo.
    --math.clamp(..., -self.maxAngle, self.maxAngle): asegura que el ángulo final esté limitado entre -maxAngle y maxAngle.
    self.angle = math.clamp(self.angle + (self.targetAngle - self.angle) * dt * rotationSpeed, -self.maxAngle, self.maxAngle)
    
    --Animación
    if self.isAnimating then
        self.animationTime = self.animationTime + dt
        if self.animationTime >= self.animationSpeed then
            self.animationTime = self.animationTime - self.animationSpeed
            self.quadIndex = self.quadIndex + 1
            
            --Si el índice supera el número de cuadros, reinicia o detén la animación
            if self.quadIndex > #self.quads then
                self.quadIndex = 1
                self.animationCycles = self.animationCycles + 1 -- Incrementar el ciclo
                
                --Detener la animación después de 3 ciclos
                if self.animationCycles >= 3 then
                    self.isAnimating = false
                    self.quadIndex = 1 --Regresa al primer cuadro
                end
            end
        end
    end

    self.hitBox:setPosition(self.position.x, self.position.y)
end

function Player:jump()
    self.velocityY = self.jumpForce
    if not self.isAnimating then
        self.isAnimating, self.quadIndex, self.animationTime = true, 1, 0
        self.animationCycles = 0 --Reiniciar el contador de ciclos
    end
    self.angle = -30
end

function Player:mousepressed(x, y, button, isTouch)
    self:jump()
end


--Función auxiliar para limitar valores
math.clamp = function(value, min, max)
    return math.max(min, math.min(max, value))
end