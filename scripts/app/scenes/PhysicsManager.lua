
    local world = nil

    local PhysicsManager = class("PhysicsManager", function()
        -- 创建
        return CCPhysicsWorld:create(0, 0)
    end)

    CollisionType = {}
    CollisionType.kCollisionTypePlayer = 1
    CollisionType.kCollisionTypeEnemy = 2

    function PhysicsManager:getInstance()
        if world == nil then
            world = PhysicsManager.new()
        end

        return world
    end

    return PhysicsManager