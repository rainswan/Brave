
local Enemy1 = class("Enemy1", function()
    return display.newSprite("#enemy1-1-1.png")
end)

function Enemy1:ctor()
    function onTouch()
        CCNotificationCenter:sharedNotificationCenter():postNotification("CLICK_ENEMY", self)
        return true
    end
    self:addAnimation()
    self.isAttack = false
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return onTouch()
    end)
end

function Enemy1:addAnimation()
    local animationNames = {"walk", "attack", "dead", "hit"}
    local animationFrameNum = {3, 3, 3, 2}

    for i = 1, #animationNames do
        local frames = display.newFrames("enemy1-" .. i .. "-%d.png", 1, animationFrameNum[i])
        local animate = display.newAnimation(frames, 0.2)
        animate:setRestoreOriginalFrame(true)
        display.setAnimationCache("enemy1-" .. animationNames[i], animate)
    end
end

function Enemy1:attack()
    if self.isAttack then
        return
    end
    self.isAttack = true
    transition.playAnimationOnce(self, display.getAnimationCache("enemy1-attack"), false, function() self.isAttack = false end)
end

return Enemy1
