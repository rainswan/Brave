
require("config")
require("framework.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    display.addSpriteFramesWithFile("image/role.plist", "image/role.pvr.ccz");
    display.addSpriteFramesWithFile("image/ui.plist", "image/ui.pvr.ccz");
    display.addSpriteFramesWithFile("image/effect.plist", "image/effect.pvr.ccz");
    self:enterScene("StartScene")
end

return MyApp
