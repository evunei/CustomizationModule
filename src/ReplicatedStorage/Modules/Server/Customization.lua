local module = {}
module.__index = module

function module.new()
    local m1 = {}
    setmetatable(m1,module)

    local dependencies = script.Parent:WaitForChild('Dependencies')

    local InsertObject = dependencies:WaitForChild('Insertion')
    local InsertModule = require(InsertObject).new()

    InsertModule:Init()


    return m1
end

return module