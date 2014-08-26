local PhysicsManager = import("..scenes.PhysicsManager")

local Player = class("Player", function()
    local sprite = display.newSprite("#player1-1-1.png", SpriteEx)
    return sprite
end)

function Player:ctor()

    self.attack = 50
    self.blood = 500

    local world = PhysicsManager:getInstance()
    self.body = world:createBoxBody(1, self:getContentSize().width/2, self:getContentSize().height)
--    self.body:bind(self)
    self.body:setCollisionType(CollisionType.kCollisionTypePlayer)
    self.body:setIsSensor(true)

    self:scheduleUpdate();
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function() self.body:setPosition(self:getPosition()) end)

    -- 缓存动画数据
    self:addAnimation()
    self:addStateMachine()
end

function Player:addAnimation()
    local animationNames = {"walk", "attack", "dead", "hit", "skill"}
    local animationFrameNum = {4, 4, 4, 2, 4}

    for i = 1, #animationNames do
        local frames = display.newFrames("player1-" .. i .. "-%d.png", 1, animationFrameNum[i])
        local animation = nil
        if animationNames[i] == "attack" then
            animation = display.newAnimation(frames, 0.1)
        else
            animation = display.newAnimation(frames, 0.2)
        end

        animation:setRestoreOriginalFrame(true)
        display.setAnimationCache("player1-" .. animationNames[i], animation)
    end
end

function Player:idle()
    transition.stopTarget(self)
end

function Player:walkTo(pos, callback)

    local function moveStop()
        self:doEvent("stop")
        if callback then
            callback()
        end
    end

    if self.moveAction then
        self:stopAction(self.moveAction)
        self.moveAction = nil
    end

    local currentPos = CCPoint(self:getPosition())
    local destPos = CCPoint(pos.x, pos.y)

    -- 感谢lcf8858同学的建议
    if pos.x < currentPos.x then
        self:setFlipX(true)
    else
        self:setFlipX(false)
    end

    local posDiff = cc.PointDistance(currentPos, destPos)
    self.moveAction = transition.sequence({CCMoveTo:create(5 * posDiff / display.width, CCPoint(pos.x,pos.y)), CCCallFunc:create(moveStop)})
    transition.playAnimationForever(self, display.getAnimationCache("player1-walk"))
    self:runAction(self.moveAction)
    return true
end

function Player:attackEnemy()

    local function attackEnd()
        self:doEvent("stop")
    end

    local animation = display.getAnimationCache("player1-attack")
    transition.playAnimationOnce(self, animation, false, attackEnd)
end

function Player:hit()

    local function hitEnd()
        self:doEvent("stop")
    end
    transition.playAnimationOnce(self, display.getAnimationCache("player1-hit"), false, hitEnd)
end

function Player:dead()
    local world = PhysicsManager:getInstance()
    world:removeBody(self.body, true)
    self.body = nil
    transition.playAnimationOnce(self, display.getAnimationCache("player1-dead"))
end

function Player:doEvent(event, ...)
    self.fsm_:doEvent(event, ...)
end

function Player:getState()
    return self.fsm_:getState()
end

function Player:addStateMachine()
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
            onhit = function (event) self:hit() end,
            ondead = function (event) self:dead() end
        },
    })

end

function Player:onExit()
    self.fsm_:doEventForce("stop")
    self:removeNodeEventListenersByEvent(cc.NODE_TOUCH_EVENT)
    self:removeNodeEventListenersByEvent(cc.NODE_ENTER_FRAME_EVENT)
end

return Player

