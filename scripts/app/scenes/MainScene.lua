
local Player = import("..roles.Player")
local Enemy1 = import("..roles.Enemy1")
local Enemy2 = import("..roles.Enemy2")
local Progress = import("..ui.Progress")
local Background = import("..ui.Background")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    self:initScene()
end

function MainScene:initScene()
    self:addTouchLayer()
    self:addRoles()
    self:addUI()
end

function MainScene:addTouchLayer()
    local function onTouch(eventName, x, y)
        if eventName == "began" then
            self.player:walkTo({x=x,y=y})
        end
    end

    self.layerTouch = display.newLayer()
    self.layerTouch:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return onTouch(event.name, event.x, event.y)
    end)
    self.layerTouch:setTouchEnabled(true)
    self.layerTouch:setPosition(ccp(0,0))
    self.layerTouch:setContentSize(CCSizeMake(display.width, display.height))
    self:addChild(self.layerTouch, -5)
end

function MainScene:addRoles()

    -- 背景
    self.background = Background.new()-- display.newSprite("image/background.png", display.cx, display.cy)
    self.background:setPosition(0, 0)
    self:addChild(self.background)

    -- 玩家
    self.player = Player.new()
    self.player:setPosition(display.left + self.player:getContentSize().width/2, display.cy)
    self:addChild(self.player)

    -- 敌人1
    self.enemy1 = Enemy1.new()
    self.enemy1:setPosition(display.right - self.enemy1:getContentSize().width/2, display.cy)
    self:addChild(self.enemy1)

    -- 敌人2
    self.enemy2 = Enemy2.new()
    self.enemy2:setPosition(display.right - self.enemy2:getContentSize().width/2 * 3, display.cy)
    self:addChild(self.enemy2)

end

function MainScene:addUI()
    -- 血量
    self.progress = Progress.new()
    self.progress:setPosition(display.left + self.progress:getContentSize().width/2, display.top - self.progress:getContentSize().height/2)
    self:addChild(self.progress)

    local itemPause = ui.newImageMenuItem({image="#pause1.png", imageSelected="#pause2.png",
        tag=1, listener = function(tag) self:pause() end})
    local itemSkill = ui.newImageMenuItem({image="#skill1.png", imageSelected="#skill2.png",
        tag=2, listener = function(tag) self:clickSkill() end})
    local menu = ui.newMenu({itemPause, itemSkill})
    itemPause:setPosition(display.right-itemPause:getContentSize().width/2, display.top-itemPause:getContentSize().height/2)
    itemSkill:setPosition(display.left + itemSkill:getContentSize().width/2, display.bottom + itemSkill:getContentSize().height/2)
    menu:setPosition(0,0)
    self:addChild(menu)
end

function MainScene:pause()
    display.pause()

--    -- 显示暂停界面
--    self.pauseLayer =
end

function MainScene:clickSkill()

end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
