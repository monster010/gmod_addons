local FakeTesterenabled = CreateConVar("ttt_faketester_enable", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should the Fake Tester be enabled?")
if !FakeTesterenabled:GetBool() then return end
if SERVER then
   AddCSLuaFile()
   util.AddNetworkString("ft result")
   util.AddNetworkString("ft failed")
   resource.AddFile("materials/VGUI/ttt/icon_randomtest.vmt")
else
   SWEP.PrintName = "Fake Tester"
   SWEP.Slot = 8

   SWEP.ViewModelFOV = 70

   SWEP.EquipMenuData = {
      type = "weapon",
      desc = "The Fake Tester will negate the random tester\n and pick a random person and test it.\nIt will output the opposite of the role. \n\nRight click to play Gaben."
   };

   SWEP.Icon = "vgui/ttt/icon_faketest.vtf"
   SWEP.ViewModelFlip = false
end


function SWEP:Precache()
	util.PrecacheSound("weapons/gaben.wav")
end

SWEP.Author = "Gamefreak"

SWEP.Base = "weapon_tttbase"

SWEP.HoldType = "normal"

SWEP.ViewModel		= "models/weapons/gamefreak/v_wiimote_meow.mdl"
SWEP.WorldModel		= "models/weapons/gamefreak/w_wiimote_meow.mdl"

SWEP.DrawCrosshair      = false
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo       = "none"

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 3

SWEP.Kind = WEAPON_ROLE
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true

SWEP.AllowDrop = true
SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true

SWEP.NoSights = true

SWEP.Delay = 10
SWEP.TextDelay = 5

function SWEP:OnRemove()
	if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
		RunConsoleCommand("lastinv")
	end
end

function GetFakeTesterPlayer()
	local result={}
	for k,v in pairs(player.GetAll()) do
		if v:IsTerror() and v:GetRole() == ROLE_TRAITOR or v:GetRole() == ROLE_INNOCENT and !v:GetNWBool("RTTested") then
			table.insert(result,v)
		end
	end
	return result[math.random(1,#result)]
end

function SWEP:HandleFakeMessages(ply)
	if !IsValid(ply) then net.Start("ft failed") net.Send(self.Owner) return end
	local role,nick=ply:GetRole(),ply:Nick()
	local owner,ownerRole,ownerNick=self.Owner,self.Owner:GetRole(),self.Owner:Nick()
	local id=ply:EntIndex()
	local txtDelay = self.TextDelay

	ply:SetNWBool("RTTested", true)

	if timer.Exists("FT Timer".. id) then return end

	for key, v in pairs(player.GetAll()) do
		if timer.Exists("RT Timer ".. v:EntIndex()) then
			self.Delay = timer.TimeLeft("RT Timer ".. v:EntIndex())
			timer.Remove("RT Timer ".. v:EntIndex())
		end
	end
	util.PrecacheSound("weapons/prank.mp3")

	hook.Add("TTTPrepareRound","Remove FT Timer "..id,function()
		for k,v in pairs(player.GetAll()) do
			timer.Remove("FT Timer "..v:EntIndex())
		end
	end)
	timer.Create("FT Timer "..id,self.Delay,1, function()
		hook.Remove("TTTPrepareRound","Remove FT Timer "..id)
		if GetRoundState()!=ROUND_ACTIVE then return end
		do
			local roleString,ownerRoleString=role==ROLE_INNOCENT and "innocent" or role==ROLE_TRAITOR and "traitor",ownerRole==ROLE_INNOCENT and "innocent" or ownerRole==ROLE_TRAITOR and "traitor" or "detective"
			DamageLog("FTester:\t"..ownerNick.." ["..ownerRoleString.."] fake tested "..nick.." ["..roleString.."]")
		end
		local valid,ownerValid=IsValid(ply),IsValid(owner)
		role,nick=valid and ply:GetRole() or role,valid and ply:Nick() or nick
		ownerRole,ownerNick=ownerValid and owner:GetRole() or ownerRole,ownerValid and owner:Nick() or nick

		net.Start("ft result")
			net.WriteEntity(ply)
			net.WriteUInt(role,2)
			net.WriteString(nick)
			net.WriteUInt(txtDelay,8)
		net.Broadcast()
	end)
end

local function PrintFakeCenteredText(txt,delay,color)
	if hook.GetTable()["FT Draw Text"] then
		hook.Remove("HUDPaint","FT Draw Text")
		hook.Add("HUDPaint","FT Draw Text", function() draw.DrawText(txt,"CloseCaption_Bold",ScrW()*0.5,ScrH()*0.2,color,TEXT_ALIGN_CENTER) end)
		timer.Adjust("FT Remove Text",delay,1, function() hook.Remove("HUDPaint","FT Draw Text") hook.Remove("TTTEndRound","FT Remove Text") hook.Remove("TTTPrepareRound","FT Remove Text") end)
	else
		hook.Add("HUDPaint","FT Draw Text", function() draw.DrawText(txt,"CloseCaption_Bold",ScrW()*0.5,ScrH()*0.2,color,TEXT_ALIGN_CENTER) end)
		hook.Add("TTTEndRound","FT Remove Text", function() hook.Remove("HUDPaint","FT Draw Text") hook.Remove("TTTEndRound","FT Remove Text") hook.Remove("TTTPrepareRound","FT Remove Text") timer.Remove("FT Remove Text") end)
		hook.Add("TTTPrepareRound","FT Remove Text", function() hook.Remove("HUDPaint","FT Draw Text") hook.Remove("TTTEndRound","FT Remove Text") hook.Remove("TTTPrepareRound","FT Remove Text") timer.Remove("FT Remove Text") end)
		timer.Create("FT Remove Text",delay,1, function() hook.Remove("HUDPaint","FT Draw Text") hook.Remove("TTTEndRound","FT Remove Text") hook.Remove("TTTPrepareRound","FT Remove Text") end)
	end
end

local function GetFakeRoleColor(role,ply,isOwner)
	if isOwner&&ply!=LocalPlayer() then return !IsValid(ply) and COLOR_ORANGE or role==ROLE_DETECTIVE and COLOR_BLUE or COLOR_PINK
	else return !(IsValid(ply)&&ply:IsTerror()) and COLOR_ORANGE or role==ROLE_INNOCENT and COLOR_RED or role==ROLE_TRAITOR and COLOR_GREEN end
end

if CLIENT then
	net.Receive("ft failed", function()
		chat.AddText("Fake Test: ", COLOR_WHITE, "The Fake Tester hasnt found an alive player that isnt a detective.")
	end)

	net.Receive("ft result", function()
		local ply,role,Nick,txtDelay,lply=net.ReadEntity(),net.ReadUInt(2),net.ReadString(),net.ReadUInt(8),LocalPlayer()
		local roleColor,textColor=GetFakeRoleColor(role,ply,false),COLOR_WHITE
		local valid=IsValid(ply)
		local nick=valid and Nick or "\""..Nick.."\" (unconnected)"

		if valid&&ply:IsSpec() then surface.PlaySound("weapons/prank.mp3") end

		if valid then
			local roleString=role==ROLE_INNOCENT and "a traitor" or role==ROLE_TRAITOR and "an innocent"
			if !(valid&&ply:IsTerror()) then chat.AddText("Random Test: ", roleColor,nick,textColor," was ",roleColor,roleString,textColor,"!")
			else if lply:IsTerror() then PrintFakeCenteredText(nick.." is "..roleString.."!",txtDelay,roleColor) end chat.AddText("Random Test: ", roleColor,nick,textColor," is ",roleColor,roleString,textColor,"!") end
		end
		chat.PlaySound()
	end)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime()+self.Delay)
	if CLIENT then return end
	if GetRoundState()==ROUND_ACTIVE then self:HandleFakeMessages(GetFakeTesterPlayer()) end
	self:Remove()
end

hook.Add("TTTPrepareRound","FTReset",function()
	for k,v in pairs(player.GetAll()) do
		v:SetNWBool("RTTested", false)
	end
end)