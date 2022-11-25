local module = {}
module.__index = module

function module.new()
    local m1 = {}
    setmetatable(m1,module)

    m1.header = "";
    m1.body = "";
    m1.buttons = {

    };
    m1.timeOut = 0;

    return m1
end

function module:Init()
    self:Open()
    task.delay(self.timeOut,function()
        self:Close
    end)
end

function module:Open()
    
end

function module:Close()
    
end

return module