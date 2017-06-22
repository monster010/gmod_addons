local EVENT = {}

EVENT.Title = "Free for all!"

function EVENT:Begin()
	for i, ply in pairs(self:GetAlivePlayers()) do
		if ply:GetRole() == ROLE_TRAITOR or (ply.GetEvil and ply:GetEvil()) or ply:GetRole() == ROLE_DETECTIVE then
			ply:GiveEquipmentItem(EQUIP_RADAR)
			ply:ConCommand("ttt_radar_scan")
		end
		timer.Simple(0.1, function()
			ply:Give("weapon_ttt_knife")
			ply:Give("weapon_ttt_push")
		end)
	end
end

Randomat:register("freeforall", EVENT)
