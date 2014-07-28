
local Player = class("Player", function()
    local sprite = display.newSprite("#player1-1-1.png")
    return sprite
end)

function Player:ctor()
    -- 缓存动画数据
    self:addAnimation()
end
function Player:addUI()
--    self.mBlood =
end

function Player:addAnimation()
    local animationNames = {"walk", "attack", "dead", "hit", "skill"}
    local animationFrameNum = {4, 4, 4, 2, 4}

    for i = 1, #animationNames do
        local frames = display.newFrames("player1-" .. i .. "-%d.png", 1, animationFrameNum[i])
        local animation = display.newAnimation(frames, 0.2)
        display.setAnimationCache("player1-" .. animationNames[i], animation)
    end
end

function Player:walkTo(pos, callback)

    local function moveStop()
        transition.stopTarget(self)
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
    local posDiff = cc.PointDistance(currentPos, destPos)
    self.moveAction = transition.sequence({CCMoveTo:create(5 * posDiff / display.width, CCPoint(pos.x,pos.y)), CCCallFunc:create(moveStop)})
    transition.playAnimationForever(self, display.getAnimationCache("player1-walk"))
    self:runAction(self.moveAction)
    return true
end

function Player:attack()
    transition.playAnimationOnce(self, display.getAnimationCache("player1-attack"))
end

function Player:dead()
    transition.playAnimationOnce(self, display.getAnimationCache("player1-dead"))
end

function Player:addStateMachine()
    self.fsm_ = {}
    cc.GameObject.extend(self.fsm_)
    :addComponent("components.behavior.StateMachine")
    :exportMethods()

    self.fsm_:setupState({
        events = {
            {name = "idle", from = "*",   to = "idle" },
            {name = "move",  from = "idle",  to = "move"},
            {name = "attack", from = {"idle", "move", "hit"},  to = "attack"   },
            {name = "hit", from = "idle", to = "hit"   },
            {name = "dead",  from = "hit",    to = "dead"},
        },

        callbacks = {
            onbeforestart = function(event) self:log("[FSM] STARTING UP") end,
            onstart       = function(event) self:log("[FSM] READY") end,
            onbeforewarn  = function(event) self:log("[FSM] START   EVENT: warn!", true) end,
            onbeforepanic = function(event) self:log("[FSM] START   EVENT: panic!", true) end,
            onbeforecalm  = function(event) self:log("[FSM] START   EVENT: calm!",  true) end,
            onbeforeclear = function(event) self:log("[FSM] START   EVENT: clear!", true) end,
            onwarn        = function(event) self:log("[FSM] FINISH  EVENT: warn!") end,
            onpanic       = function(event) self:log("[FSM] FINISH  EVENT: panic!") end,
            oncalm        = function(event) self:log("[FSM] FINISH  EVENT: calm!") end,
            onclear       = function(event) self:log("[FSM] FINISH  EVENT: clear!") end,
            onleavegreen  = function(event) self:log("[FSM] LEAVE   STATE: green") end,
            onleaveyellow = function(event) self:log("[FSM] LEAVE   STATE: yellow") end,
            onleavered    = function(event)
                self:log("[FSM] LEAVE   STATE: red")
                self:pending(event, 3)
                self:performWithDelay(function()
                    self:pending(event, 2)
                    self:performWithDelay(function()
                        self:pending(event, 1)
                        self:performWithDelay(function()
                            self.pendingLabel_:setString("")
                            event.transition()
                        end, 1)
                    end, 1)
                end, 1)
                return "async"
            end,
            ongreen       = function(event) self:log("[FSM] ENTER   STATE: green") end,
            onyellow      = function(event) self:log("[FSM] ENTER   STATE: yellow") end,
            onred         = function(event) self:log("[FSM] ENTER   STATE: red") end,
            onchangestate = function(event) self:log("[FSM] CHANGED STATE: " .. event.from .. " to " .. event.to) end,
        },
    })
end

return Player

