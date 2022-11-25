local module = {}
module.__index = module

function module.new()
    local m1 = {}
    setmetatable(m1,module)

    local dependencies = script.Parent:WaitForChild('Dependencies')

    local AccessObject = dependencies:WaitForChild('Accessorize')
    local AccessModule = require(AccessObject).new()

    AccessModule:Init()


    return m1
end

return module