Tipper = LibStub("AceAddon-3.0"):NewAddon("Tipper", "AceConsole-3.0", "AceComm-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local sharedLib = LibStub("LibSharedMedia-3.0")
local Frames = {}

function Tipper:OnSlashTip(input)
    local target = GetUnitName("target")
    local sender = GetUnitName("player")

    if target == nil then
        return
    end

    Tipper:SendCommMessage("tippertip", sender.."-"..target, "RAID");
end

function Tipper:GetColorForUnit(unit)
    local localizedClass, playerClass = UnitClass(unit)

    if playerClass == "PRIEST" then
        return 1.0, 1.0, 1.0
    end
    if playerClass == "SHAMAN" then
        return 0.00,0.44,0.87
    end
    if playerClass == "ROGUE" then
        return 1.00,0.96,0.41
    end
    if playerClass == "DRUID" then
        return 1.00,0.49,0.04
    end
    if playerClass == "HUNTER" then
        return 0.67,0.83,0.45
    end
    if playerClass == "MAGE" then
        return 0.25,0.78,0.92
    end
    if playerClass == "PALADIN" then
        return 0.96,0.55,0.73
    end
    if playerClass == "WARLOCK" then
        return 0.53,0.53,0.93
    end
    if playerClass == "WARRIOR" then
        return 0.78,0.61,0.43
    end
    if playerClass == "MONK" then
        return 0.0,1.00,0.6
    end
    if playerClass == "DEATHKNIGHT" then
        return 0.77,0.12,0.23
    end
    if playerClass == "DEMONHUNTER" then
        return 0.64,0.12,0.23
    end
    
    return 1.0, 1.0, 1.0
 end

function Tipper:FindNextVisible()
    for i=0,3,1 do
        if not Frames[i]:IsVisible() then
            return Frames[i]
        end
    end

    return nil
end

function Tipper:OnCommReceived(input, input2, input3)
    local sender, target = strsplit("-", input2)

    local frame = Tipper:FindNextVisible()

    if frame == nil then
        return;
    end

    local senderR, senderG, senderB = Tipper:GetColorForUnit(sender)

    frame.SenderIcon:SetLabel(sender)
    frame.SenderIcon.label:SetTextColor(senderR, senderG, senderB)
    frame.SenderIcon.label:SetVertexColor(senderR, senderG, senderB)
    SetPortraitTexture(frame.SenderIcon.image, sender)

    frame.TipIcon:SetImage("Interface\\AddOns\\Tipper\\shards_splash.tga")

    frame.TargetIcon:SetLabel(target)

    local targetR, targetG, targetB = Tipper:GetColorForUnit(target)

    frame.TargetIcon.label:SetTextColor(targetR, targetG, targetB)
    frame.TargetIcon.label:SetVertexColor(targetR, targetG, targetB)

    SetPortraitTexture(frame.TargetIcon.image, target)

    C_Timer.After(5.0, function()
        frame.frame:Hide()
    end)

    frame.frame:Show()
    frame:DoLayout()
end

function Tipper:InitNewFrame(x, y)
    local frame = AceGUI:Create("TipperSimpleGroup")
    frame:SetWidth(350)
    frame:SetHeight(200)
    frame:SetPoint("TOPLEFT", x, -y)
    frame:SetLayout("Flow")

    frame.frame:Hide()

    frame.SenderIcon = AceGUI:Create("Icon")
    frame.SenderIcon:SetImageSize(32, 32)

    frame.TipIcon = AceGUI:Create("Icon")
    frame.TipIcon:SetImageSize(48, 48)

    frame.TargetIcon = AceGUI:Create("Icon")
    frame.TargetIcon:SetImageSize(32, 32)

    frame:AddChild(frame.SenderIcon)
    frame:AddChild(frame.TipIcon)
    frame:AddChild(frame.TargetIcon)

    frame:DoLayout()

    return frame
end

function Tipper:OnInitialize()
    Frames[0] = Tipper:InitNewFrame(0,0)
    Frames[1] = Tipper:InitNewFrame(0,50)
    Frames[2] = Tipper:InitNewFrame(0,100)
    Frames[3] = Tipper:InitNewFrame(0,150)

    Tipper:RegisterChatCommand("tipplayer", "OnSlashTip")
    Tipper:RegisterComm("tippertip", "OnCommReceived")
end