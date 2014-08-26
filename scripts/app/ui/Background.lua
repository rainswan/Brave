local Background = class("Background", function()
    return display.newLayer()
end)

function Background:ctor()
    self.sprite = display.newSprite("image/background.png")
    self.sprite2 = display.newSprite("image/background2.png")
    self.currentSprite = self.sprite
    self.sprite:setPosition(display.cx, display.cy)
    self.sprite2:setPosition(display.cx + display.width, display.cy)
    self:addChild(self.sprite2)
    self:addChild(self.sprite)
end

function Background:move(direct, withSprite)
    if self.isMove then
        return
    end

    local moveArgs = {time = 2.0, y = 0}
    if direct == "left" then
        moveArgs.x = -display.width
    else
        moveArgs.x = display.width
    end

    local seq = transition.sequence({CCMoveBy:create(moveArgs.time, CCPoint(moveArgs.x, moveArgs.y)),
                                CCCallFunc:create(function () self:moveEnd() end)})
    transition.moveBy(self.sprite, moveArgs)
    transition.execute(self.sprite2, seq)

    if withSprite then
        transition.moveBy(withSprite, moveArgs)
    end

    self.isMove = true
end

function Background:moveEnd()
    local x1 = self.sprite:getPosition()
    self.isMove = false
    if(x1 == -display.cx) then
        self.sprite:setPosition(display.cx + display.width, display.cy)
    else
        self.sprite2:setPosition(display.cx + display.width, display.cy)
    end

    CCNotificationCenter:sharedNotificationCenter():postNotification("BACKGROUND_MOVE_END")
end

return Background
