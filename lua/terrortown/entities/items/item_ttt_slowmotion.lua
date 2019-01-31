if SERVER then
	AddCSLuaFile()
	resource.AddWorkshop("611911370")

	resource.AddFile("sound/slowmotion/sm_enter.wav")
	resource.AddFile("sound/slowmotion/sm_exit.wav")

	resource.AddFile("materials/VGUI/ttt/slowmotion_icon.vmt")
	resource.AddFile("materials/VGUI/ttt/slowmotion_icon.vtf")
	resource.AddFile("materials/vgui/ttt/perks/hud_slowmo.png")

	util.AddNetworkString("SlowMotionSound")
	util.AddNetworkString("SM_Ask2")
	util.AddNetworkString("SMReload")
end

local smduration = CreateConVar("ttt_slowmotion_duration", 5, {FCVAR_ARCHIVE}, "How long should the slowmotion last?")
local smcooldown = CreateConVar("ttt_slowmotion_cooldown", 45, {FCVAR_ARCHIVE}, "How long should the slowmotion cooldown last?")

ITEM.hud = Material("vgui/ttt/perks/hud_slowmo.png")
ITEM.EquipMenuData = {
	type = "item_active",
	name = "item_SlowMotion",
	desc = "item_SlowMotion_desc"
}
ITEM.material = "vgui/ttt/slowmotion_icon.vmt"
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}

if CLIENT then
	local function askSM()
		net.Start("SM_Ask2")
		net.SendToServer()
	end
	concommand.Add("slowmotion", askSM)

	LANG.AddToLanguage("English", "item_SlowMotion", "SlowMotion")
	LANG.AddToLanguage("English", "item_SlowMotion_desc", "A Killing Floor like SlowMotion,\nit slows down the game for a short time.\nCooldown is 45 Seconds.\nbind a key for 'SlowMotion' to use it.")

	local function SlowMotionSound()
		local enabled = net.ReadBool()

		surface.PlaySound("slowmotion/sm_" .. (enabled and "enter" or "exit") .. ".wav")
	end
	net.Receive("SlowMotionSound", SlowMotionSound)

	net.Receive("SMReload", function()
		chat.AddText("SlowMotion: ", Color(255, 255, 255), "Your Slow Motion is ready again!")
		chat.PlaySound()
	end)
else
	local plymeta = FindMetaTable("Player")
	local SlowMotion_active = false

	local function SlowMotionSound(enabled)
		net.Start("SlowMotionSound")
		net.WriteBool(enabled)
		net.Broadcast()
	end

	function plymeta:EnableSlowMotion2()
		if SlowMotion_active then return end

		if self:HasEquipmentItem("item_ttt_slowmotion") and not self.SlowMotion_used then
			self.SlowMotion_used = true

			game.SetTimeScale(0.3)

			SlowMotion_active = true

			SlowMotionSound(true)

			self:SMReset2()
		end
	end

	function plymeta:SMReset2()
		local slf = self

		timer.Create("SMReset" .. self:EntIndex(), smduration:GetFloat(), 1, function()
			if IsValid(slf) and slf.SlowMotion_used then
				game.SetTimeScale(1)

				SlowMotion_active = false

				SlowMotionSound(false)

				if slf:IsActive() then
					slf:ReloadSM2()
				end
			end
		end)
	end

	function plymeta:ReloadSM2()
		local slf = self

		timer.Create("SMReload" .. self:EntIndex(), smcooldown:GetFloat(), 1, function()
			if IsValid(slf) and slf:IsTerror() then
				net.Start("SMReload")
				net.Send(slf)

				slf.SlowMotion_used = false
			end
		end)
	end

	net.Receive("SM_Ask2", function(len, ply)
		ply:EnableSlowMotion2()
	end)

	hook.Add("TTTPrepareRound", "BeginRoundSM", function()
		for _, v in ipairs(player.GetAll()) do
			v.SlowMotion_used = false

			if timer.Exists("SMReset" .. v:EntIndex()) then
				game.SetTimeScale(1)

				SlowMotion_active = false

				SlowMotionSound(false)

				if v:IsTerror() then
					v:ReloadSM2()
				end

				timer.Remove("SMReset" .. v:EntIndex())
			end

			timer.Remove("SMReload" .. v:EntIndex())
		end
	end)
end