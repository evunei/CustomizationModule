local module = {}
module.__index = module

local SingleAssetIds = {
    [2] = "GraphicTShirt",
    [11] = "Shirt",
    [12] = "Pants",
    [17] = "Head",
    [18] = "Face",
    [27] = "Torso",
    [28] = "RightArm",
    [29] = "LeftArm",
    [30] = "LeftLeg",
    [31] = "RightLeg",
    [48] = "ClimbAnimation",
    [49] = "DeathAnimation",
    [50] = "FallAnimation",
    [51] = "IdleAnimation",
    [52] = "JumpAnimation",
    [53] = "RunAnimation",
    [54] = "SwimAnimation",
    [55] = "WalkAnimation",
}
local AccessoryAssetIds = { -- AssetTypes that are comma-seperated (accessories)
    [8] = "HatAccessory",
    [41] = "HairAccessory",
    [42] = "FaceAccessory",
    [43] = "NeckAccessory",
    [44] = "ShouldersAccessory",
    [45] = "FrontAccessory",
    [46] = "BackAccessory",
    [47] = "WaistAccessory",
}
local LayeredAccessoryAssetIds = {
    [64] = Enum.AccessoryType.TShirt,
    [65] = Enum.AccessoryType.Shirt,
    [66] = Enum.AccessoryType.Pants,
    [67] = Enum.AccessoryType.Jacket,
    [68] = Enum.AccessoryType.Sweater,
    [69] = Enum.AccessoryType.Shorts,
    [70] = Enum.AccessoryType.LeftShoe,
    [71] = Enum.AccessoryType.RightShoe,
    [72] = Enum.AccessoryType.DressSkirt,
}


function module.new()
    local m1 = {}
    setmetatable(m1,module)

    local InsertService = game:GetService('InsertService')

    local ClientEvents = script.Parent.Parent.Parent.Parent.Events.Client
    local NotifyEvent = Instance.new("RemoteEvent",ClientEvents)
    NotifyEvent.Name = "FireNotification"

    function m1.InsertAccessory(player,assetId)

        local success1, productInfo = pcall(game.MarketplaceService.GetProductInfo, game.MarketplaceService, assetId)
        if not success1 then 
            NotifyEvent:FireClient(player,15,"Error","Invalid Id.".."\n".."Item Id: "..assetId)
            assert(false,"Invalid ID.") 
        end

        local typeId = productInfo.AssetTypeId

        local success, model = pcall(InsertService.LoadAsset, InsertService, assetId)
        if success and model then
            local accessory = model:GetChildren()[1]
            if accessory then
                local Humanoid = player.Character.Humanoid
                local HumanoidDescription = Humanoid:GetAppliedDescription()
                
                if SingleAssetIds[typeId] then
                    HumanoidDescription[SingleAssetIds[typeId]] = assetId
                elseif AccessoryAssetIds[typeId] then
                    if string.find(HumanoidDescription[AccessoryAssetIds[typeId]], tostring(assetId)) then return end
                    HumanoidDescription[AccessoryAssetIds[typeId]] ..= ","..assetId
                elseif LayeredAccessoryAssetIds[typeId] then
                    local accessories = HumanoidDescription:GetAccessories(true)
					table.insert(accessories, {
						Order = #accessories,
						AssetId = assetId,
					    AccessoryType = LayeredAccessoryAssetIds[typeId]
					})
					HumanoidDescription:SetAccessories(accessories, true)
                else
                    NotifyEvent:FireClient(player,15,"Error","You have equipped an unsupported Item.".."\n".."Item Id: "..assetId)
                    assert(false,"Unsupported Item.")
                    return
                end
                Humanoid:ApplyDescription(HumanoidDescription)
                NotifyEvent:FireClient(player,15,"Success!","You have equipped the following item:".."\n".."Item Name: "..productInfo.Name.."\n".."Item Id: "..assetId)
            end
        end
    end

    function m1.ClearAccessory(player,name)
        if not tonumber(name) then
            if not name then
                local list = ""
                for _,child in pairs(player.Character:GetChildren())do
                    if (child:IsA("Accessory"))then
                        list = list.."\n"..child.Name
                        child:Destroy()
                    end
                end 
                NotifyEvent:FireClient(player,15,"Success!","You have removed the following items:".."\n"..list)
                return
            end
            for _,child in pairs(player.Character:GetChildren())do
                if child.Name:lower() == name:lower() then
                    if not (child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic")) then return end
                    child:Destroy()
    
                    local Humanoid = player.Character.Humanoid
                    NotifyEvent:FireClient(player,15,"Success!","You have removed the following item:".."\n"..child.Name)
                end
            end
        else
            local success, model = pcall(InsertService.LoadAsset, InsertService, tonumber(name))
            if success and model then
                local accessory = model:GetChildren()[1]
                if accessory then
                    local find = player.Character:FindFirstChild(accessory.Name)
                    if find then
                        find:Destroy()
                    end
                end
            end
        end
    end

    return m1
end

function module:Init()
    print("Init")
    local Events = script.Parent.Parent.Parent.Parent.Events

    -- Accessory Insertion
    local InsertEvent = Instance.new("RemoteEvent",Events.Server)
    local InsertClient = Instance.new("BindableEvent",Events.Client)

    InsertEvent.Name = "InsertEvent"
    InsertClient.Name = "InsertClient"

    InsertEvent.OnServerEvent:Connect(function(player,assetId)
        self.InsertAccessory(player,assetId)
    end)
    InsertClient.Event:Connect(function(player,assetId)
        self.InsertAccessory(player,assetId)
    end)

    -- Accessory Deletion
    local ClearEvent = Instance.new("RemoteEvent",Events.Server)
    local ClearClient = Instance.new("BindableEvent",Events.Client)

    ClearEvent.Name = "ClearEvent"
    ClearClient.Name = "ClearClient"

    ClearEvent.OnServerEvent:Connect(function(player,name)
        self.ClearAccessory(player,name)
    end)
    ClearClient.Event:Connect(function(player,name)
        self.ClearAccessory(player,name)
    end)

end

return module