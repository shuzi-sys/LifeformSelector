Script.Load("lua/LifeformSelector/shared.lua")

local Params = {
    steamID = "string (64)",
    lifeformName = "string(16)"
}

Shared.RegisterNetworkMessage(
    "UpdateSelectedLifeform", Params
)
Shared.RegisterNetworkMessage(
    "receiveUpdateLifeformicon", Params
)

Shared.RegisterNetworkMessage(
    "InitScoreboardLifeforms", Params
)

Shared.RegisterNetworkMessage(
    "InitScoreboardLifeformsCall", {}
)
