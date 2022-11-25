local module = {}
module.__index = module

function module.new()
    local m1 = {}
    setmetatable(m1,module)

    local dependencies = script.Parent:WaitForChild('Dependencies')

    local AccessoryObject = dependencies:WaitForChild('Accessories')
    local AccessoryModule = require(AccessoryObject).new()

    

    return m1
end


return module