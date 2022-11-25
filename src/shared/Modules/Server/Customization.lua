local module = {}
module.__index = module

function module.new()
    local m1 = {}
    setmetatable(m1,module)

    

    return m1
end


return module