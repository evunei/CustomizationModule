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
    m1.guiObject = nil;
    m1.isOpen = false;

    return m1
end

function module:Init()
    if not (self.guiObject:IsA("Frame")) then assert(false,"GuiObject must be a Frame.") return end
    self:Open()
    task.delay(self.timeOut,function()
        self:Close()
    end)
end

function module:Open()
    if (self.isOpen) then return end
    self.guiObject:TweenPosition(
        UDim2.new(0.5,0,0.5,0), -- Final position the tween should reach
        Enum.EasingDirection.In, -- Direction of the easing
        Enum.EasingStyle.Sine, -- Kind of easing to apply
        2, -- Duration of the tween in seconds
        true, -- Whether in-progress tweens are interrupted
        function ()
            self.isOpen = true;
        end -- Function to be callled when on completion/cancelation
    )
end

function module:Close()
    if not(self.isOpen) then return end
    self.guiObject:TweenPosition(
        UDim2.new(0.5,0,-1,0), -- Final position the tween should reach
        Enum.EasingDirection.In, -- Direction of the easing
        Enum.EasingStyle.Sine, -- Kind of easing to apply
        2, -- Duration of the tween in seconds
        true, -- Whether in-progress tweens are interrupted
        function ()
            self.isOpen = false;
        end -- Function to be callled when on completion/cancelation
    )
end

return module