
local PauseLayer = class("PauseLayer", function ()
    return display.newColorLayer(ccc4(162,162,162,128))
end)

function PauseLayer:ctor()
    self:addUI()
    self:addTouch()
end

function PauseLayer:addUI()
    local background = display.newSprite("#pause-bg.png")
    background:setPosition(display.cx, display.cy)
    self:addChild(background)

    local home = ui.newImageMenuItem({
        image = "#home-1.png",
        imageSelected = "#home-2.png",
        listener = function()
            self:home()
        end
    })

    local resume = ui.newImageMenuItem({
        image = "#continue-1.png",
        imageSelected = "#continue-2.png",
        listener = function()
            self:resume()
        end
    })

    local backgroundSize = background:getContentSize()

    home:setPosition(backgroundSize.width/3, backgroundSize.height/2)
    resume:setPosition(backgroundSize.width*2/3, backgroundSize.height/2)

    local menu = ui.newMenu({home, resume})
    menu:setPosition(display.left, display.bottom)

    background:addChild(menu)
end

function PauseLayer:addTouch()
    local function onTouch(name, x, y)
        print("PauseLayer:addTouch")
    end

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return onTouch(event.name, event.x, event.y)
    end)

    self:setTouchEnabled(true)
end

function PauseLayer:resume()
    self:removeFromParentAndCleanup(true)
    display.resume()
end

function PauseLayer:home()
    display.resume()
    self:removeNodeEventListenersByEvent(cc.NODE_TOUCH_EVENT)
    self:removeFromParentAndCleanup(true)
    display.replaceScene(require("app.scenes.StartScene").new())
end

return PauseLayer
