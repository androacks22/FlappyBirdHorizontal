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
            elseif asset.type == "sound" then
                Resources:NewSound(asset.path, asset.name, asset.soundType)
            elseif asset.type == "quad" then
                if(asset.unique == true) then
                    Resources:NewQuad(
                        asset.name,
                        asset.imageName,
                        asset.x or 0,
                        asset.y or 0,
                        asset.w or 32,
                        asset.h or 32
                    )

                else
                    Resources:NewTileQuads(
                        asset.name,
                        asset.imageName,
                        asset.x or 0,
                        asset.y or 0,
                        asset.w or 32,
                        asset.h or 32,
                        asset.cols or 1,
                        asset.rows or 1,
                        asset.spacing or 0
                    )
                end
            end

            self.loadedAssets = self.loadedAssets + 1
            self.loadingProgress = (self.loadedAssets / self.totalAssets) * 100

            -- Pausar la corutina para permitir el renderizado
            coroutine.yield()
        end

        print(Resources:ListAssets())

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
