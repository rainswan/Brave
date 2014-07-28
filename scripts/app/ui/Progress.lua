
local Progress = class("Progress", function()
        return display.newSprite("#player-progress-bg.png")
    end)

function Progress:ctor()
    self.fill = display.newProgressTimer("#player-progress-fill.png", display.PROGRESS_TIMER_BAR)
    self.fill:setMidpoint(CCPoint(0, 0.5))
    self.fill:setBarChangeRate(CCPoint(1.0, 0))
    self.fill:setPosition(self:getContentSize().width/2, self:getContentSize().height/2)
    self:addChild(self.fill)
    self.fill:setPercentage(50)
end

function Progress:setProgress(progress)
    self.fill:setPercentage(progress)
end

return Progress
