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


    return m1
end

function module:Init()
    print("Init Client")
    local Events = script.Parent.Parent.Parent.Parent.Events

    -- Accessory Insertion
    local InsertEvent = Events.Server:WaitForChild('InsertEvent')
    local InsertClient = Events.Client:WaitForChild('InsertClient')


    -- Accessory Deletion
    local ClearEvent = Events.Server:WaitForChild('ClearEvent')
    local ClearClient = Events.Client:WaitForChild('ClearClient')

    -- Initialize Accessory Logging
    local RunService = game:GetService('RunService')

    local Outfit = {
        Accessories = {};
        Shirt = "";
        Pants = "";
        ShirtGraphic = "";
        Face = "";
    }

    local lastOutfit = {}

    RunService.Stepped:Connect(function(time, deltaTime)
        if not game.Players.LocalPlayer.Character then return end
        local Humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
        local HumanoidDescription = Humanoid:GetAppliedDescription()

        -- Get Accessories
        Outfit.Accessories = HumanoidDescription:GetAccessories(true)

        -- Get Clothing
        Outfit.Shirt = HumanoidDescription.Shirt
        Outfit.Pants = HumanoidDescription.Pants
        Outfit.ShirtGraphic = HumanoidDescription.GraphicTShirt
        
        -- Get Face
        Outfit.Face = HumanoidDescription.Face

        -- Get Scale
        -- For Future Updates

        if lastOutfit == Outfit then return end
        lastOutfit = Outfit
        -- Debug
        print(Outfit)
        -- Get Asset Name
        for i,d in pairs(Outfit)do
            if i=="Accessories" then
                for _,a in pairs(d)do
                    local success1, productInfo = pcall(game.MarketplaceService.GetProductInfo, game.MarketplaceService, a)
                    if not success1 then assert(false,"Invalid ID.") end

                    print(productInfo.Name)

                end
            else
                if( d=="" or d==0) then return end
                print(d)
                local success1, productInfo = pcall(game.MarketplaceService.GetProductInfo, game.MarketplaceService, d)
                if not success1 then assert(false,"Invalid ID.") end

                print(productInfo.Name)
            end
        end

    end)
end

return module