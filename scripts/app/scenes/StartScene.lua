
local StartScene = class("StartScene", function()
    return display.newScene("StartScene")
end)

function StartScene:ctor()

    local background = display.newSprite("image/start-bg.jpg")
    background:setPosition(display.cx, display.cy)
    self:addChild(background)

    local item = ui.newImageMenuItem({image="#start1.png", imageSelected="#start2.png",
        listener = function()
            display.replaceScene(require("app.scenes.MainScene").new())
        end})
    item:setPosition(display.cx, display.cy)
    local menu = ui.newMenu({item})
    menu:setPosition(display.left, display.bottom)

    self:addChild(menu)
end

function StartScene:onExit()
end

return StartScene

