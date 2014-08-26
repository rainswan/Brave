local Progress = import("..ui.Progress")
local PhysicsManager = import("..scenes.PhysicsManager")

local Enemy2 = class("Enemy2", function()
    return display.newSprite("#enemy2-1-1.png")
end)

function Enemy2:ctor()

    self.attack = 20
    self.blood = 100

    local world = PhysicsManager:getInstance()
    self.body = world:createBoxBody(1, self:getContentSize().width/2, self:getContentSize().height)
--    self.body:bind(self)
    self.body:setCollisionType(CollisionType.kCollisionTypeEnemy)
    self.body:setIsSensor(true)
    self.body.isCanAttack = false

    self:scheduleUpdate();
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,
        function()
            if self.body then self.body:setPosition(self:getPosition()) end
        end)

    local function onTouch()
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

    self:addUI()
    self:addStateMachine()
end

function Enemy2:addUI()
    self.progress = Progress.new("#small-enemy-progress-bg.png", "#small-enemy-progress-fill.png")
    local size = self:getContentSize()
    self.progress:setPosition(size.width*2/3, size.height + self.progress:getContentSize().height/2)
    self:addChild(self.progress)
end

function Enemy2:addAnimation()
    local animationNames = {"walk", "attack", "dead", "hit"}
    local animationFrameNum = {3, 3, 3, 2}

    for i = 1, #animationNames do
        local frames = display.newFrames("enemy2-" .. i .. "-%d.png", 1, animationFrameNum[i])
        local animate = display.newAnimation(frames, 0.2)
        animate:setRestoreOriginalFrame(true)
        display.setAnimationCache("enemy2-" .. animationNames[i], animate)
    end
end

function Enemy2:getCanAttack()
    -- 是否能够被攻击，默认不可以
    return self.body.isCanAttack or false
end

function Enemy2:idle()
    transition.stopTarget(self)
end

function Enemy2:attack()
    local function attackEnd()
        self:doEvent("stop")
    end

    transition.playAnimationOnce(self, display.getAnimationCache("enemy2-attack"), false, attackEnd)
end

function Enemy2:hit(attack)
    self.blood = self.blood - attack
    if self.blood <= 0 then
        self.blood = 0
        self.progress:setProgress(self.blood)
        self:doEvent("beKilled")
        return
    else
        self.progress:setProgress(self.blood)
    end

    local function hitEnd()
        self:doEvent("stop")
    end

    transition.playAnimationOnce(self, display.getAnimationCache("enemy2-hit"), false, hitEnd)
end

function Enemy2:dead()
    local world = PhysicsManager:getInstance()
    world:removeBody(self.body, true)
    self.body = nil

    local function remove()
        self:removeFromParentAndCleanup()
        CCNotificationCenter:sharedNotificationCenter():postNotification("ENEMY_DEAD", self)
    end

    transition.playAnimationOnce(self, display.getAnimationCache("enemy2-dead"), true, remove)
end

function Enemy2:doEvent(event, ...)
    self.fsm_:doEvent(event, ...)
end

function Enemy2:getState()
    return self.fsm_:getState()
end

function Enemy2:addStateMachine()
    self.fsm_ = {}
    cc.GameObject.extend(self.fsm_)
    :addComponent("components.behavior.StateMachine")
    :exportMethods()

    self.fsm_:setupState({
        -- 初始状态
        initial = "idle",

        -- 事件和状态转换
        events = {
            -- t1:clickScreen; t2:clickEnemy; t3:beKilled; t4:stop
            {name = "clickScreen", from = {"idle", "attack"},   to = "walk" },
            {name = "clickEnemy",  from = {"idle", "walk"},  to = "attack"},
            {name = "beKilled", from = {"idle", "walk", "attack", "hit"},  to = "dead"},
            {name = "beHit", from = {"idle", "walk", "attack"}, to = "hit"},
            {name = "stop", from = {"walk", "attack", "hit"}, to = "idle"},
        },

        -- 状态转变后的回调
        callbacks = {
            onidle = function (event) self:idle() end,
            onattack = function (event) self:attackEnemy() end,
            onhit = function (event) self:hit(event.args[1].attack) end,
            ondead = function (event) self:dead() end
        },
    })

end

function Enemy2:onExit()
    self:removeNodeEventListenersByEvent(cc.NODE_TOUCH_EVENT)
    self:removeNodeEventListenersByEvent(cc.NODE_ENTER_FRAME_EVENT)
end

return Enemy2
