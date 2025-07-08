Shared.Message("LifeformSelector lua cargado")
-- Storing old functions
local base_Initialize = GUIScoreboard.Initialize
local base_Update = GUIScoreboard.Update
local base_SendKeyEvent = GUIScoreboard.SendKeyEvent
local base_Uninitialize = GUIScoreboard.Uninitialize
local base_CreatePlayerItem = GUIScoreboard.CreatePlayerItem
--
local coords = {
    Onos = {1/360 , 1/68, 69/360, 66/68},
    Fade = {91/360, 15/68, 131/360, 66/68},
    Lerk = {145/360, 21/68, 213/360, 58/68},
    Gorge = {229/360, 22/68, 275/360, 57/68},
    Skulk = {294/360, 25/68, 348/360, 54/68}
}
--
kMouseButtonhold = false
kScoreboardfirstpress = false
kSelfIndexPos = 0
kSelfLifeformIcon = nil
kSelfplayerItem = nil
kPlayerLifeFormIconSize = 20
kPlayerLifeFormRightPadding = 4
kPlayerLifeFormTexture = PrecacheAsset("ui/alien_hivestatus_commicons.dds")
kFlushedIcons = false
kPlayerLifeforms = {} -- This is the "persistence" table. This will hold previous changes so you can receive past changed icons.
ScoreboardInstance = nil -- we will use this when receiving network messages
--

function GUIScoreboard:SendKeyEvent(key, down)
    base_SendKeyEvent(self, key, down)
    -- First, we must reference our own row on the tab scoreboard. 
          local playerList = self.teams[3]["PlayerList"]
            for p = 1, #playerList do
                local playerItem = playerList[p]
                local clientIndex = playerItem["ClientIndex"]
                local steamId = GetSteamIdForClientIndex(clientIndex)
                if (steamId == Client.GetSteamId()) then
                    kSelfIndexPos = clientIndex
                    kSelfplayerItem = playerItem
                    kSelfLifeformIcon = playerItem["Lifeform"]
                    break
                end
    end

-- On the first pull, receive scoreboard updates. Then proceed with the handling of hovermenu options.
    if (self.visible and not self.kScoreboardfirstpress) then
        Shared.Message("Pulling initial persistence")
        Client.SendNetworkMessage("InitScoreboardLifeformsCall", {})
        self.kScoreboardfirstpress = true
    elseif (self.visible and self.kScoreboardfirstpress) then
        if key == InputKey.MouseButton0 and not kMouseButtonhold then
            Shared.Message("click hooked from scoreboard")
            kMouseButtonhold = true 
            local mouseX, mouseY = Client.GetCursorPosScreen()
            if GUIItemContainsPoint(kSelfLifeformIcon, mouseX, mouseY) then
                Shared.Message("Clicked on your lifeform in the scoreboard")
                self.hoverMenu:ResetButtons()
                self.hoverMenu:AddButton("Skulk", GUIScoreboard.kRedColor * 0.5 , GUIScoreboard.kRedColor * 0.75 , Color(1, 1, 1, 1), function () UpdateLifeformicon("Skulk", kSelfLifeformIcon, false) end )
                self.hoverMenu:AddButton("Gorge", GUIScoreboard.kRedColor * 0.5 , GUIScoreboard.kRedColor * 0.75 , Color(1, 1, 1, 1), function () UpdateLifeformicon("Gorge", kSelfLifeformIcon,false) end )
                self.hoverMenu:AddButton("Lerk", GUIScoreboard.kRedColor * 0.5 , GUIScoreboard.kRedColor * 0.75 , Color(1, 1, 1, 1), function () UpdateLifeformicon("Lerk", kSelfLifeformIcon,false) end )
                self.hoverMenu:AddButton("Fade", GUIScoreboard.kRedColor * 0.5 , GUIScoreboard.kRedColor * 0.75 , Color(1, 1, 1, 1), function () UpdateLifeformicon("Fade", kSelfLifeformIcon,false) end )
                self.hoverMenu:AddButton("Onos", GUIScoreboard.kRedColor * 0.5 , GUIScoreboard.kRedColor * 0.75 , Color(1, 1, 1, 1), function () UpdateLifeformicon("Onos", kSelfLifeformIcon,false) end )
            end
        else if key == InputKey.MouseButton0 and kMouseButtonhold then
            Shared.Message("click is being held from scoreboard")
        end
        kMouseButtonhold = false
    end
end
end

-- We will hook into the creation part, get the return, add the lifeform section and return it back with it. It's beautiful :')
-- NOTE: "No lifeform" texture is given on creation time as everybody starts without one selected. Network messages will change this.
function GUIScoreboard:CreatePlayerItem()
local playerItem = base_CreatePlayerItem(self)
local currentColumnX = ConditionalValue(GUIScoreboard.screenWidth < 1280, GUIScoreboard.kPlayerItemWidth, self:GetTeamItemWidth() - GUIScoreboard.kTeamColumnSpacingX * 10)
local playerLifeform = GUIManager:CreateGraphicItem()
playerLifeform:SetSize (Vector(kPlayerLifeFormIconSize + 5, kPlayerLifeFormIconSize, 0) * GUIScoreboard.kScalingFactor)
playerLifeform:SetAnchor(GUIItem.Left, GUIItem.Center)
playerLifeform:SetPosition(Vector(currentColumnX - 40, -kPlayerLifeFormIconSize/2, 0) * GUIScoreboard.kScalingFactor)
playerLifeform:SetTexture(kPlayerLifeFormTexture)
playerLifeform:SetTextureCoordinates(293/360, 24/68, 348/360, 53/68)
playerLifeform:SetIsVisible(false)
playerLifeform:SetColor(Color(1, 1, 1, 1))
playerItem.Background:AddChild(playerLifeform)
playerItem.Lifeform = playerLifeform
return playerItem

end

-- This hook will do the following things
    -- 1) Check if the scoreboard is visible (If it's not, then should we clean all the icons?)
    -- 2) Check if the client IS in the alien teams (I dont want enemies to know who is playing each lifeform, sounds dumb no?)
    -- 3) Cicle through every player in the aliens team make their logo visible.
function GUIScoreboard:Update(deltaTime)
    base_Update(self, deltaTime)
    local vis = self.visible and not self.hiddenOverride
    local self_Player = Client:GetLocalPlayer()
    -- When not visible, we check if we should clean all the lifeform icons because we could be changing teams in middle of the warmup and they'd still show
    if not vis then
        if self.kShouldflush == true then 
        self:ForceFlushIcons()
        Shared.Message("Forzando el flusheo")
        self.kShouldflush = false
        end
    return end 
    -- Then we proceed with the standard logic.
    if not GameInfo:GetState() == kGameState.WarmUp and self.kShouldflush then 
        self:ForceFlushIcons()
        Shared.Message("Etapa de warmup finalizada, íconos flusheados")
        return end
        if not self_Player or self_Player:GetTeamNumber() == kTeam1Index then return end
        local playerList = self.teams[3]["PlayerList"]
          for p = 1, #playerList do
           local playerItem = playerList[p]
           local clientIndex = playerItem["ClientIndex"]
           local playerItemSteamID = GetSteamIdForClientIndex(clientIndex)
           if (playerItemSteamID:GetTeamNumber() ~= kTeam2Index) then return end
           if (playerItem["Lifeform"]) then
           -- We use the persistence / replication table to embed previously changed lifeforms. 
            if (self.kPlayerLifeforms[steamID]) then
                Shared.Message("Embebiendo desde la tabla de persistencia")
                UpdateLifeformIcon(self.kPlayerLifeforms[steamID], playerItem["Lifeform"], true)
            end
           playerItem["Lifeform"]:SetIsVisible(true)
        end 
        end
    self.kShouldflush = true
end 

function GUIScoreboard:ForceFlushIcons()
for t = 1, #self.teams do
local playerList = self.teams[t]["PlayerList"]
          for p = 1, #playerList do
           local playerItem = playerList[p]
           Shared.Message("Este player existe")
           if (playerItem["Lifeform"]) then
           playerItem["Lifeform"]:SetIsVisible(true)
            end
        end
end
end


-- it must be processed from the client since the server apparently cant receive objects (like playerItem.Lifeform)
function GUIScoreboard:receiveLifeformChanges(networkTable)
    local steamID = networkTable.steamID
    local lifeformName = networkTable.lifeformName
self.kPlayerLifeforms[steamID] = lifeformName
Shared.Message("Se guardo en la tabla kPlayerLifeforms local el lifeformName" .. self.kPlayerLifeforms[steamID])
Shared.Message("Para el steam id: " .. steamID)
end


function UpdateLifeformicon(lifeformName, lifeformItem, networked)
if lifeformName == "Gorge" then
    Shared.Message("Intento de cambio de textura") 
    lifeformItem:SetTextureCoordinates(coords.Gorge)
elseif lifeformName == "Skulk" then
    lifeformItem:SetTextureCoordinates(coords.Skulk)
elseif lifeformName == "Fade" then
    lifeformItem:SetTextureCoordinates(coords.Fade)
elseif lifeformName == "Lerk" then
    lifeformItem:SetTextureCoordinates(coords.Lerk)
elseif lifeformName == "Onos" then
    lifeformItem:SetTextureCoordinates(coords.Onos)
end

-- Change made by own client
if networked == false then
Shared.Message("Despachando icono a los demas clientes")
local clientIndex = Client.GetLocalClientIndex()
local clientsteamID = GetSteamIdForClientIndex(clientIndex)
    local networkTable = {
        steamID = clientsteamID,
        lifeformName = lifeformName
    }
Client.SendNetworkMessage("UpdateSelectedLifeform", networkTable, true)
end

end

function GUIScoreboard:Initialize()
base_Initialize(self)
self.kPlayerLifeforms = {}
GUIScoreboard.ScoreboardInstance = self
end

function GUIScoreboard:InitScoreboardLifeforms(steamID, lifeformName)
self.kPlayerLifeforms[steamID] = lifeformName
Shared.Message("Se guardó una entrada nueva")
end


Client.HookNetworkMessage("receiveUpdateLifeformicon", function(networkTable)
    Shared.Message("Paquete recibido en el cliente")
    if (GUIScoreboard.ScoreboardInstance) then
        Shared.Message("Paquete recibido e instancia conocida encontrada")
    GUIScoreboard.ScoreboardInstance:receiveLifeformChanges(networkTable)
    end
end)
Client.HookNetworkMessage("InitScoreboardLifeforms", function(msg)
if (GUIScoreboard.ScoreboardInstance) then
    Shared.Message("Mensaje recibido para guardar entrada nueva del init.")
    GUIScoreboard.ScoreboardInstance:InitScoreboardLifeforms(msg.steamID, msg.lifeformName)
end
end)