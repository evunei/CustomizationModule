for _,system in pairs(game.ReplicatedStorage.Modules.Client:GetChildren())do
    if system:IsA("ModuleScript") then
        local sys = require(system).new()
    end
end