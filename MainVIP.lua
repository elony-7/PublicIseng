--========================
-- Preload Fluent UI Library
--========================

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
print("Loaded Fluent:", Fluent)

-- Helper function for notifications
local function Notify(title, content, duration)
    Fluent:Notify({
        Title = title,
        Content = content,
        Duration = duration or 3
    })
end

Notify("Notification", "Script is loading...", 5)

--========================
-- Preload Modules
--========================
local AutoFishing = loadstring(game:HttpGet("https://raw.githubusercontent.com/elony-7/PublicIseng/main/autofishingnodelay"))()
local TeleportToPlayer = loadstring(game:HttpGet("https://raw.githubusercontent.com/elony-7/PublicIseng/main/Teleporttoplayer.lua"))()
local PlayerModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/elony-7/PublicIseng/main/PlayerModule.lua"))()
local antiafkmodule = loadstring(game:HttpGet("https://raw.githubusercontent.com/elony-7/PublicIseng/main/Antiafk.lua"))()
local TouchFlingModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/elony-7/PublicIseng/main/TouchFlingModule"))()


--print("Modules loaded:", AutoFishing, AutoReel, AutoCastPerfect, TeleportModule, TeleportToPlayer, PurchaseWeather,PlayerModule, autosellmodule, antiafkmodule)

--========================
-- Create Main Window
--========================
local Window = Fluent:CreateWindow({
    Title = "IkanTerbang By Elony7k V1.4",
    SubTitle = "",
    TabWidth = 140,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})
print("Created Window:", Window)

--========================
-- Create Tabs
--========================
local FarmTab = Window:AddTab({Title = "Farm", Icon = "play"})
--local TeleportTab = Window:AddTab({Title = "Teleport", Icon = "map"})
local TeleportPlayerTab = Window:AddTab({Title = "Teleport to Player", Icon = "user"})
local PlayerTab = Window:AddTab({Title = "Player", Icon = "user-cog"})
--local AutoSellTab = Window:AddTab({Title = "Auto Sell", Icon = "shopping-cart"})
--local WeatherTab = Window:AddTab({Title = "Weather", Icon = "cloud-rain"})
local ExtraTab = Window:AddTab({Title = "Extra", Icon = "settings"})
local FlingTab = Window:AddTab({Title = "Fling", Icon = "zap"})


local Options = Fluent.Options 

--========================
-- Farm Tab 
--========================

--=== Auto Fishing Toggle ===
do
    FarmTab:AddToggle("AutoFishingPerfect", {
        Title = "🎣 Auto Fishing Perfect",
        Description = "Automatically starts fishing minigame perfectly.",
        Default = false
    }):OnChanged(function(val)
        if val then
            AutoFishing.Start()
            print("✅ Auto Fishing Perfect ENABLED")
            Notify("✅ Auto Fishing Perfect", "Auto Fishing Perfect ENABLED", 2)
        else
            AutoFishing.Stop()
            print("❌ Auto Fishing Perfect DISABLED")
            Notify("❌ Auto Fishing Perfect", "Auto Fishing Perfect DISABLED", 2)
        end
    end)
end


--========================
-- Teleport to Player Tab
--========================
do
    local playerList = TeleportToPlayer.GetInitialPlayers() or {}
    if #playerList == 0 then table.insert(playerList, "None") end
    local selectedPlayer = playerList[1]

    TeleportToPlayer.selectedPlayerName = selectedPlayer

    local playerDropdown = TeleportPlayerTab:AddDropdown("SelectPlayerDropdown", {
        Title = "Select Player",
        Values = playerList,
        Multi = false,
        Default = selectedPlayer
    })

    playerDropdown:SetValue(selectedPlayer)
    playerDropdown:OnChanged(function(value)
        selectedPlayer = value
        TeleportToPlayer.selectedPlayerName = value
        print("Selected player:", value)
    end)

    TeleportPlayerTab:AddButton({
        Title = "Teleport to Player",
        Description = "Teleport to the selected player",
        Callback = function()
            TeleportToPlayer.TeleportTo(selectedPlayer)
            Notify("Teleport", "Teleported to " .. selectedPlayer, 2)
        end
    })
end


--========================
-- Player Tab
--========================
do -- Unlimited Jump Toggle
    PlayerTab:AddToggle("UnlimitedJump", {
        Title = "♾️ Unlimited Jump",
        Description = "Allows jumping infinitely",
        Default = false
    }):OnChanged(function(val)
        PlayerModule.SetUnlimitedJump(val)
    end)
end    

do  -- NoClip Toggle
    PlayerTab:AddToggle("NoClip", {
        Title = "🚫 NoClip",
        Description = "Makes character pass through walls",
        Default = false
    }):OnChanged(function(val)
        PlayerModule.SetNoClip(val)
    end)
end

--========================
-- Extra Tab
--========================
do
    local antiAFK = ExtraTab:AddToggle("AntiAFKToggle", {
        Title = "🛡️ Anti-AFK",
        Description = "Prevents being disconnected due to inactivity",
        Default = false
    })

    antiAFK:OnChanged(function(val)
        if val then
            antiafkmodule.start()
        else
            antiafkmodule.stop()
        end
        Notify("🛡️ Anti-AFK", val and "Anti-AFK ENABLED" or "Anti-AFK DISABLED", 2)
    end)
end

do
    ExtraTab:AddButton({
        Title = "🗑️ Delete Fishing Effect(Reduce overtime lag)",
        Description = "Mengurangi lag dalam jangka panjang",
        Callback = function()
            local cosmetic = workspace:FindFirstChild("CosmeticFolder")
            if cosmetic then
                cosmetic:Destroy()
                Notify("🗑️ Deleted", "CosmeticFolder has been deleted!", 2)
            else
                Notify("❌ Not Found", "CosmeticFolder does not exist.", 2)
            end
        end
    })
end

do
    ExtraTab:AddButton({
        Title = "🧹 Remove Notifications GUI",
        Description = "Mengurangi Lag dan Notifikasi Tertumpuk",
        Callback = function()
            local pg = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

            local removed = false

            local small = pg:FindFirstChild("Small Notification")
            if small then
                small:Destroy()
                removed = true
            end

            local textNotif = pg:FindFirstChild("Text Notifications")
            if textNotif then
                textNotif:Destroy()
                removed = true
            end

            if removed then
                Notify("🧹 Cleaned", "Removed notification GUIs successfully!", 2)
            else
                Notify("❌ Nothing Found", "No notification GUIs were found.", 2)
            end
        end
    })
end


--========================
-- Fling Tab
--========================
do
    FlingTab:AddToggle("TouchFlingToggle", {
        Title = "⚡ Hempaskan!",
        Description = "Hempaskan Player lain ke langit ke-7. Rawan Freeze Tergantung Device",
        Default = false
    }):OnChanged(function(val)
        TouchFlingModule.Toggle(val)

        if val then
            Notify("⚡ Hempaskan!", "Hempaskan Enabled", 2)
        else
            Notify("⚡ Hempaskan!", "Hempaskan DISABLED", 2)
        end
    end)
end



--========================
-- Final Notification
--========================
Notify("Notification", "The Script has loaded successfully!", 3)
