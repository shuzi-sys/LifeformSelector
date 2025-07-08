Script.Load("lua/LifeformSelector/client.lua")
Shared.Message("LifeformSelector lua cargado")

local base_Initialize = GUIAlienBuyMenu:Initialize()

function GUIAlienBuyMenu:Initialize()
    base_Initialize(self)

    if porComando == true then
    self:_UninitializeGlowieParticles()
self:_UninitializeCorners()
self:_UninitializeUpgradeButtons()
self:_UninitializeSlots()

self.evolveButtonText(Locale.ResolveString("ABM_ELEGIR_LIFEFORM"))

    GUI.DestroyItem(self.mouseOverInfoResIcon)
    self.mouseOverInfoResIcon = nil

    GUI.DestroyItem(self.mouseOverInfoResAmount)
    self.mouseOverInfoResAmount = nil

    GUI.DestroyItem(self.mouseOverInfoHealthIcon)
    self.mouseOverInfoHealthIcon = nil

    GUI.DestroyItem(self.mouseOverInfoHealthAmount)
    self.mouseOverInfoHealthAmount = nil

    GUI.DestroyItem(self.mouseOverInfoArmorIcon)
    self.mouseOverInfoArmorIcon = nil

    GUI.DestroyItem(self.mouseOverInfoArmorAmount)
    self.mouseOverInfoArmorAmount = nil

    end
end

