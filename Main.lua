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
		Duration = duration or 3,
	})
end

Notify("Notification", "Script is loading...", 5)

--========================
-- Preload Modules
--========================
local AutoFishing =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/elony-7/RBXAFSH/main/Module/autofishingtest.lua"))()
local TeleportToPlayer =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/elony-7/RBXAFSH/main/Module/Teleporttoplayer.lua"))()
local PlayerModule =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/elony-7/RBXAFSH/main/Module/PlayerModule.lua"))()
local antiafkmodule =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/elony-7/RBXAFSH/main/Module/Antiafk.lua"))()

print("Modules loaded:", AutoFishing, TeleportToPlayer, PlayerModule, antiafkmodule)

--========================
-- Create Main Window
--========================
local Window = Fluent:CreateWindow({
	Title = "IkanTerbang Hub",
	SubTitle = "",
	TabWidth = 140,
	Size = UDim2.fromOffset(580, 400),
	Acrylic = true,
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.RightControl,
})
print("Created Window:", Window)

--========================
-- Create Tabs
--========================
local FarmTab = Window:AddTab({ Title = "Farm", Icon = "play" })
--local TeleportTab = Window:AddTab({Title = "Teleport", Icon = "map"})
local TeleportPlayerTab = Window:AddTab({ Title = "Teleport to Player", Icon = "user" })
local PlayerTab = Window:AddTab({ Title = "Player", Icon = "user-cog" })
--local AutoSellTab = Window:AddTab({Title = "Auto Sell", Icon = "shopping-cart"})
--local WeatherTab = Window:AddTab({Title = "Weather", Icon = "cloud-rain"})
local ExtraTab = Window:AddTab({ Title = "Extra", Icon = "settings" })

local Options = Fluent.Options

--========================
-- Farm Tab
--========================

--=== Auto Fishing Toggle ===
do
	FarmTab:AddToggle("AutoFishingPerfect", {
		Title = "🎣 Auto Fishing Perfect",
		Description = "Automatically starts fishing minigame perfectly.",
		Default = false,
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
	if #playerList == 0 then
		table.insert(playerList, "None")
	end
	local selectedPlayer = playerList[1]

	TeleportToPlayer.selectedPlayerName = selectedPlayer

	local playerDropdown = TeleportPlayerTab:AddDropdown("SelectPlayerDropdown", {
		Title = "Select Player",
		Values = playerList,
		Multi = false,
		Default = selectedPlayer,
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
		end,
	})
end

--========================
-- Extra Tab
--========================
do
	local antiAFK = ExtraTab:AddToggle("AntiAFKToggle", {
		Title = "🛡️ Anti-AFK",
		Description = "Prevents being disconnected due to inactivity",
		Default = false,
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

--========================
-- Final Notification
--========================
Notify("Notification", "The Script has loaded successfully!", 3)
