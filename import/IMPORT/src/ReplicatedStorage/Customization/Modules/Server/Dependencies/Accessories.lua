local module = {}
module.__index = module

function module.new()
    local m1 = {}
    setmetatable(m1,module)

    local InsertService = game:GetService('InsertService')

    function m1.InsertAccessory(player,assetId)
        local success, model = pcall(InsertService.LoadAsset, InsertService, assetId)
        if success and model then
            local accessory = model:GetChildren()[1]
            if accessory then
                accessory.Parent = player.Character
                return assetId
            end
        end
        return nil
    end

    return m1
end


return module