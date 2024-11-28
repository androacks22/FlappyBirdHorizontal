Resources = {
    assets = {
        images = {},
        sounds = {},
        fonts = {},
        shaders = {}
    }
}

--- Libera un recurso de la memoria.
-- @param category Categoría del recurso (images, sounds, fonts, shaders).
-- @param name Nombre del recurso.
-- @return true si se liberó el recurso, false si no se encontró.
function Resources:Release(category, name)
    if self.assets[category] and self.assets[category][name] then
        self.assets[category][name] = nil
        print("Released " .. category .. " asset: " .. name)
        return true
    end
    print("Asset not found: " .. name)
    return false
end

--- Lista todos los recursos cargados, organizados por categoría.
function Resources:ListAssets()
    print("Loaded assets:")
    for category, assets in pairs(self.assets) do
        print("Category: " .. category)
        for name, _ in pairs(assets) do
            print("  - " .. name)
        end
    end
end

-- Almacena un asset en la categoría especificada
-- @param category: tipo de recurso (images, sounds, fonts)
-- @param name: nombre del recurso
-- @param asset: recurso cargado
function Resources:StoreAsset(category, name, asset)
    if not self.assets[category] then
        self.assets[category] = {}
    end
    self.assets[category][name] = asset

    print("Stored " .. category .. " asset: " .. name)
end

-- Crea y almacena una imagen
-- @param path: ruta de la imagen
-- @param name: nombre para referirse a la imagen
function Resources:NewImage(path, name)
    local asset = love.graphics.newImage(path)
    self:StoreAsset("images", name, asset)
end

--- Carga un recurso de imagen de manera asincrónica.
-- @param path Ruta al archivo de imagen.
-- @param name Nombre con el que se almacenará el recurso.
-- @param callback (opcional) Función que se ejecutará una vez cargada la imagen.
function Resources:AsyncLoadImage(path, name, callback)
    local thread = love.thread.newThread([[
        local path, name = ...
        local image = love.graphics.newImage(path)
        return name, image
    ]])
    
    thread:start(path, name)

    -- Registrar el callback en el hilo principal
    local channel = love.thread.getChannel("ResourceChannel")
    local watcher = love.run
    love.run = function()
        watcher()
        local data = channel:pop()
        if data then 
            self:StoreAsset("images", data.name, data.img)
            if callback then callback(data.img) end
        end
    end
end

-- Carga una imagen existente por su nombre
-- @param name: nombre de la imagen
-- @return: imagen cargada o nil si no existe
function Resources:LoadImage(name)
    return self.assets.images[name]
end

-- Crea y almacena un sonido
-- @param path: ruta del sonido
-- @param name: nombre para referirse al sonido
-- @param type: tipo de fuente de sonido (static o stream)
function Resources:NewSound(path, name, type)
    local asset = love.audio.newSource(path, type or "static")
    self:StoreAsset("sounds", name, asset)
end

-- Carga un sonido existente por su nombre
-- @param name: nombre del sonido
-- @return: sonido cargado o nil si no existe
function Resources:LoadSound(name)
    return self.assets.sounds[name]
end

-- Crea y almacena una fuente
-- @param path: ruta de la fuente
-- @param size: tamaño de la fuente
-- @param name: nombre para referirse a la fuente
function Resources:NewFont(path, size, name)
    local asset = love.graphics.newFont(path, size)
    self:StoreAsset("fonts", name, asset)
end

-- Carga una fuente existente por su nombre
-- @param name: nombre de la fuente
-- @return: fuente cargada o nil si no existe
function Resources:LoadFont(name)
    return self.assets.fonts[name]
end

--- Crea y almacena un nuevo shader.
-- @param vertexPath Ruta al archivo de shader de vértices.
-- @param fragmentPath Ruta al archivo de shader de fragmentos.
-- @param name Nombre con el que se almacenará el shader.
function Resources:NewShader(vertexPath, fragmentPath, name)
    local shader = love.graphics.newShader(vertexPath, fragmentPath)
    self:StoreAsset("shaders", name, shader)
end

--- Devuelve un shader cargado previamente.
-- @param name Nombre del shader.
-- @return El shader si existe, nil si no.
function Resources:LoadShader(name)
    return self.assets.shaders[name]
end

--- Carga todos los recursos de una carpeta específica.
-- @param folderPath Ruta a la carpeta.
-- @param category Categoría del recurso (images, sounds, fonts).
function Resources:LoadFolder(folderPath, category)
    local lfs = love.filesystem
    for _, file in ipairs(lfs.getDirectoryItems(folderPath)) do
        local fullPath = folderPath .. "/" .. file
        if lfs.isFile(fullPath) then
            local name = file:match("(.+)%..+$") -- Quitar la extensión
            if category == "images" then
                self:NewImage(fullPath, name)
            elseif category == "sounds" then
                self:NewSound(fullPath, name)
            elseif category == "fonts" then
                self:NewFont(fullPath, 16, name) -- Tamaño por defecto
            end
        end
    end
    print("Loaded all assets from folder: " .. folderPath)
end

--- Calcula la memoria utilizada por los recursos cargados.
-- @return Memoria total utilizada en bytes.
function Resources:GetMemoryUsage()
    local total = 0
    for _, assets in pairs(self.assets) do
        for _, asset in pairs(assets) do
            if asset:type() == "Image" then
                total = total + asset:getWidth() * asset:getHeight() * 4
            elseif asset:type() == "Font" then
                total = total + asset:getSize() * 1024 -- Estimación
            elseif asset:type() == "Shader" then
                total = total + 4096 -- Aproximación para shaders
            end
        end
    end
    return total
end
