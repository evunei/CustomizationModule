local module = {}
module.__index = module

function module.new()
    local m1 = {}
    setmetatable(m1,module)

    -- Accessorize
    local dependencies = script.Parent:WaitForChild('Dependencies')

    local AccessObject = dependencies:WaitForChild('Accessorize')
    local AccessModule = require(AccessObject).new()

    AccessModule:Init()
    -- GUI
    local GuiObject = dependencies.GUI:WaitForChild("GuiObject")
    -- Events
    local FireNotification = script.Parent.Parent.Parent.Events.Client:WaitForChild('FireNotification')
    FireNotification.OnClientEvent:Connect(function(timeOut,header,body)
        local GuiModule = require(GuiObject).new()
        GuiModule.guiObject = script.Parent.Dependencies.GUI:WaitForChild('PopUpPrompt'):Clone().Frame
        GuiModule.timeOut = timeOut
        GuiModule.header = header
        GuiModule.body = body
        GuiModule:Init()
    end)

    return m1
end

return module