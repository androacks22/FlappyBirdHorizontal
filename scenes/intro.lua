require("assetLoader")

IntroScene = class("IntroScene", Scene)

-- Inicializar la escena
function IntroScene:initialize()
    self.loadingProgress = 0 
    self.isLoadingComplete = false
    self.waitingAfterLoad = false
    self.timerAfterLoad = 0
    self.totalAssets = #AssetLoader.toLoad -- Número total de assets
    self.loadedAssets = 0              -- Contador de assets cargados

    -- Crear la corutina para cargar los assets
    self.assetLoader = coroutine.create(function()
        for _, asset in ipairs(AssetLoader.toLoad) do
            if asset.type == "image" then
                Resources:NewImage(asset.path, asset.name)

            elseif asset.type == "quad" then
                Resources:NewQuad()
            elseif asset.type == "sound" then
                Resources:NewSound(asset.path, asset.name, asset.soundType)
            end
            self.loadedAssets = self.loadedAssets + 1
            self.loadingProgress = (self.loadedAssets / self.totalAssets) * 100

            -- Pausar la corutina para permitir el renderizado
            coroutine.yield()
        end

        -- Marcar la carga como completada
        self.isLoadingComplete = true
        self.waitingAfterLoad = true   -- Activar el temporizador post-carga
    end)
end

function IntroScene:draw()
    love.graphics.clear(0.1, 0.1, 0.1)

    local barWidth = maid.sizeX * 0.6
    local barHeight = 30
    local barX = (maid.sizeX - barWidth) / 2
    local barY = maid.sizeY * 0.9 - barHeight

    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", barX, barY, barWidth, barHeight)

    love.graphics.setColor(0.2, 0.8, 0.2)
    love.graphics.rectangle("fill", barX, barY, barWidth * (self.loadingProgress / 100), barHeight)

    love.graphics.setColor(1, 1, 1)
    local progressText = self.waitingAfterLoad and "Carga completa!" or string.format("Cargando: %d%%", math.floor(self.loadingProgress))
    love.graphics.printf(progressText, barX, barY - 25, barWidth, "center")

    love.graphics.print("Pantalla de carga pitera.", maid.sizeX / 2 - 75, maid.sizeY / 2)
end

function IntroScene:update(dt)
    if not self.isLoadingComplete and self.assetLoader then
        local success, errorMessage = coroutine.resume(self.assetLoader)
        if not success then
            error("Error en la corutina: " .. errorMessage)
        end
    elseif self.waitingAfterLoad then
        self.timerAfterLoad = self.timerAfterLoad + dt
        if self.timerAfterLoad >= 1 then
            SceneSystem:SetScene(Level)
        end
    end
end
