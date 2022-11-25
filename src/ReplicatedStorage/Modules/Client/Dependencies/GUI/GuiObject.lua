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
    m1.reset = false;
    m1.isInitialized = false;

    return m1
end

function module:Init()
    if (self.isInitialized) then return end
    if not (self.guiObject:IsA("Frame")) then assert(false,"GuiObject must be a Frame.") return end
    
    self.isInitialized = true
    self.guiObject.Parent.Parent = game.Players.LocalPlayer.PlayerGui
    -- Positioning
    self.guiObject.Parent.ResetOnSpawn = self.reset
    self.guiObject.Position = UDim2.new(0.5,0,2,0)
    self.guiObject.AnchorPoint = Vector2.new(0.5,0.5)
    self:Open()

    -- Time Out
    if self.timeOut > 0 then
        task.delay(self.timeOut,function()
            self:Close()
        end)
    end

    -- Closing
    if(self.guiObject:WaitForChild("Close",0.5)) then
        if self.guiObject.Close:IsA("TextButton") or self.guiObject.Close:IsA("ImageButton") then
            self.guiObject.Close.MouseButton1Down:Connect(function()
                self:Close()
            end)
        end
    end

    -- Text
    if not(self.guiObject:WaitForChild("Header",0.5)) then return end
    if not(self.guiObject:WaitForChild("Body",0.5)) then return end

    self.guiObject.Header.Text = self.header
    self.guiObject.Body.Text = self.body
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
        UDim2.new(0.5,0,2,0), -- Final position the tween should reach
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