
local GameoverLayer = class("GameoverLayer", function()
    return display.newLayer()
end)

function GameoverLayer:ctor()
    local background = display.newSprite("#pause-bg.png")
    background:setPosition(display.cx, display.cy)
    self:addChild(background)

    local background_title = display.newSprite("#gameover-title.png")
    background_title:setPosition(background:getPositionX()/2, background:getPositionY())
    background:addChild(background_title)

    local itemHome = ui.newImageMenuItem({image="#home-1.png", imageSelected="#home-2.png", listener = function()
            self:removeFromParentAndCleanup(true)
            display.replaceScene(require("app.scenes.StartScene").new())
        end})
    local itemRetry = ui.newImageMenuItem({image="#retry-1.png", imageSelected="#retry-2.png", listener = function()
            self:removeFromParentAndCleanup(true)
        end})
    local itemNext = ui.newImageMenuItem({image="#continue-1.png", imageSelected="#、continue-2.png", listener = function ()
            self:removeFromParentAndCleanup(true)
        end})

    itemHome:setPosition(background:getContentSize().width/4, itemHome:getContentSize().height)
    itemRetry:setPosition(background:getContentSize().width/2, itemHome:getContentSize().height)
    itemNext:setPosition(background:getContentSize().width*3/4, itemHome:getContentSize().height)

    local menu = ui.newMenu({itemHome, itemRetry, itemNext})
    background:addChild(menu)

end

return GameoverLayer
