
local Enemy2 = class("Enemy2", function()
    return display.newSprite("#enemy2-1-1.png")
end)

function Enemy2:ctor()
    self:addAnimation()
    self.isAttack = false
end

function Enemy2:addAnimation()
    local animationNames = {"walk", "attack", "dead"}
    local animationFrameNum = {3, 3, 3}

    for i = 1, #animationNames do
        local frames = display.newFrames("enemy2-" .. i .. "-%d.png", 1, animationFrameNum[i])
        local animate = display.newAnimation(frames, 0.2)
        animate:setRestoreOriginalFrame(true)
        display.setAnimationCache("enemy2-" .. animationNames[i], animate)
    end
end

function Enemy2:attack()
    if self.isAttack then
        return
    end
    self.isAttack = true
    transition.playAnimationOnce(self, display.getAnimationCache("enemy2-attack"), false, function() self.isAttack = false end)
end

return Enemy2
