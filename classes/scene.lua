Scene = class("Scene")

function Scene:initialize(name)
    --Esto identifica la escena
    --Por defecto es "None", si obtienes esto... algo estás haciendo mal : )
    self.name = name or "None"

    --Los objetos de la escena
    self.objects = {}
end

function Scene:draw()
    
end

function Scene:update(dt)
    
end

--Instancia un objeto dentro de la escena
function Scene:Instance(object)
    local pos = #self.objects+1
    table.insert(self.objects, pos, object())
    print("inserted " .. tostring(object) .. " in " .. pos )
    return self.objects[pos]
end

--Destruye un objeto dentro de la escena
function Scene:Destroy(object)
    for i, obj in ipairs(self.objects) do
        if obj == object then
            table.remove(self.objects, i) -- Elimina el objeto de la lista
            print("Destroyed object at position " .. i)
            return true
        end
    end
    print("Object not found")
    return false
end

function Scene:DestroyScene()
    self.objects = nil
    collectgarbage()
    self.objects = {}
end