require("classes.scene")

SceneSystem = {}

function SceneSystem:initialize()
    self.currentScene = nil
end

function SceneSystem:draw()
    if not self.currentScene then return end

    if self.currentScene.draw then
        self.currentScene:draw()
    end
end

function SceneSystem:update(dt)
    if not self.currentScene then return end

    if self.currentScene.update then
        self.currentScene:update(dt)
    end
end

function SceneSystem:SetScene(scene)

    if self.currentScene and self.currentScene.DestroyScene then
        self.currentScene:DestroyScene()
    end

    self.currentScene = scene()
end