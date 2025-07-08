Shared.Message("LifeformSelector lua cargado")

local base_Initialize = GUIAlienBuyMenu.Initialize
local base_UninitializeGlowieParticles = GUIAlienBuyMenu._UninitializeGlowieParticles
local base_UninitializeSlots = GUIAlienBuyMenu._UninitializeSlots
local base_UninitializeEvolveButton = GUIAlienBuyMenu._UninitializeEvolveButton
local base__UninitializeUpgradeButtons = GUIAlienBuyMenu.__UninitializeUpgradeButtons

function customdestroy()

    for i, currentButton in ipairs(self.upgradeButtons) do

        GUI.DestroyItem(currentButton.Icon)
        if currentButton.Background then
            GUI.DestroyItem(currentButton.Background)
        end

    end
    self.upgradeButtons = { }

end

function InitializeEvolveButtonCustom()
        self.selectedAlienType = AlienBuy_GetCurrentAlien()

    self.evolveButtonBackground = GUIManager:CreateGraphicItem()
    self.evolveButtonBackground:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.evolveButtonBackground:SetSize(Vector(GUIAlienBuyMenu.kEvolveButtonWidth, GUIAlienBuyMenu.kEvolveButtonHeight, 0))
    self.evolveButtonBackground:SetPosition(Vector(-GUIAlienBuyMenu.kEvolveButtonWidth / 2, GUIAlienBuyMenu.kEvolveButtonHeight / 2 + GUIAlienBuyMenu.kEvolveButtonYOffset, 0))
    self.evolveButtonBackground:SetTexture(GUIAlienBuyMenu.kBuyMenuTexture)
    self.evolveButtonBackground:SetTexturePixelCoordinates(GUIUnpackCoords(GUIAlienBuyMenu.kEvolveButtonTextureCoordinates))
    self.background:AddChild(self.evolveButtonBackground)

    self.evolveButtonVeins = GUIManager:CreateGraphicItem()
    self.evolveButtonVeins:SetSize(Vector(GUIAlienBuyMenu.kEvolveButtonWidth - kVeinsMargin * 2, GUIAlienBuyMenu.kEvolveButtonHeight - kVeinsMargin * 2, 0))
    self.evolveButtonVeins:SetPosition(Vector(kVeinsMargin, kVeinsMargin, 0))
    self.evolveButtonVeins:SetTexture(GUIAlienBuyMenu.kBuyMenuTexture)
    self.evolveButtonVeins:SetTexturePixelCoordinates(GUIUnpackCoords(GUIAlienBuyMenu.kEvolveButtonVeinsTextureCoordinates))
    self.evolveButtonVeins:SetColor(Color(1, 1, 1, 0))
    self.evolveButtonBackground:AddChild(self.evolveButtonVeins)

    self.evolveButtonText = GUIManager:CreateTextItem()
    self.evolveButtonText:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.evolveButtonText:SetFontName(kFont)
    self.evolveButtonText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.evolveButtonText)
    self.evolveButtonText:SetTextAlignmentX(GUIItem.Align_Center)
    self.evolveButtonText:SetTextAlignmentY(GUIItem.Align_Center)
    self.evolveButtonText:SetText(Locale.ResolveString("ABM_ELEGIR_LIFEFORM"))
    self.evolveButtonText:SetColor(Color(0, 0, 0, 1))
    self.evolveButtonText:SetPosition(Vector(0, 0, 0))
    self.evolveButtonVeins:AddChild(self.evolveButtonText)

end

function GUIAlienBuyMenu:Initialize()
    if porComando == true then
        Shared.Message("Abriste por comando")

        base_Initialize(self)

        customdestroy()

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


    else
        base_Initialize(self)
        Shared.Message("Abriste con B")
    end


end

