local emoteTokens = {
    "bow", "cheer", "cry", "dance", "flirt", "hug", "kiss", "laugh",
    "point", "salute", "shy", "sit", "sleep", "thank", "wave", "yes"
}

EmotesButtonMixin = {}

function EmotesButtonMixin:OnLoad()
    self.Icon:SetTexture("Interface\\AddOns\\BetterEmotes\\Textures\\icon.tga")

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function EmotesButtonMixin:OnEvent(event)
    if event == "PLAYER_ENTERING_WORLD" then
        self:PopulateGrid()
    end
end

function EmotesButtonMixin:PopulateGrid()
    if not self.buttonPool then
        self.buttonPool = CreateFramePool("Button", self.Grid, "EmoteGridButtonTemplate")
    end
    self.buttonPool:ReleaseAll()

    local buttonSize, spacing, gridSize = 32, 4, 4
    local index = 1

    for row = 1, gridSize do
        for col = 1, gridSize do
            local token = emoteTokens[index]
            if token then
                local btn = self.buttonPool:Acquire()
                btn.emoteToken = token

                btn:SetPoint("TOPLEFT", self.Grid, "TOPLEFT",
                    (col-1) * (buttonSize + spacing) + 6,
                    -(row-1) * (buttonSize + spacing) - 6)

                btn.Icon:SetTexture("Interface\\AddOns\\BetterEmotes\\Textures\\"..token..".tga")

                btn:SetScript("OnClick", function() DoEmote(token:upper()) end)
                btn:SetScript("OnEnter", function(s)
                    GameTooltip:SetOwner(s, "ANCHOR_RIGHT")
                    GameTooltip:SetText(token:gsub("^%l", string.upper), 1, 1, 1)
                    GameTooltip:Show()
                end)
                btn:SetScript("OnLeave", GameTooltip_Hide)

                btn:Show()
                index = index + 1
            end
        end
    end
end

function EmotesButtonMixin:OnEnter()
    if self.hideTimer then self.hideTimer:Cancel() end
    self.Grid:Show()
end

function EmotesButtonMixin:OnLeave()
    self.hideTimer = C_Timer.After(0.3, function()
        if not self:IsMouseOver() and not self.Grid:IsMouseOver() then
            self.Grid:Hide()
        end
    end)
end