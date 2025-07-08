Script.Load("lua/LifeformSelector/server.lua")
Shared.Message("[LifeformSelector] server.lua cargado.")
LifeformChoices = {}

function lifeformreplication(Client, networkTable)
    steamID = networkTable.steamID
    LifeformChoices[steamID] = networkTable.lifeformName
    Shared.Message("El informante es de ID:" .. LifeformChoices[steamID])
    Shared.Message("Reciviendo despacho de icono con " .. networkTable.lifeformName)
Server.SendNetworkMessage("receiveUpdateLifeformicon", networkTable, true)
end

function lifeformfirstreplication(Client, message)
    Shared.Message("Recibido el initscoreboardcall")
    if not LifeformChoices or next(LifeformChoices) == nil then
        Shared.Message("Se intentó inicializar el scoreboard con lifeforms pero nadie eligió aún")
    end
for steamID, lifeformName in pairs(LifeformChoices) do
    if not steamID or not lifeformName then return end
    Shared.Message("Envío desde el servidor de paquete con entrada para lifeformfirstreplication")
Server.SendNetworkMessage(Client, "InitScoreboardLifeforms", {
    steamID = steamID,
    lifeformName = lifeformName
}, false)
end
end

Server.HookNetworkMessage("UpdateSelectedLifeform", lifeformreplication)
Server.HookNetworkMessage("InitScoreboardLifeformsCall", lifeformfirstreplication)