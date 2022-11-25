for _,system in pairs(game.ReplicatedStorage.Modules.Server:GetChildren())do
    if system:IsA("ModuleScript") then
        local sys = require(system).new()
    end
end