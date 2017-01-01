
SWEP.Base        = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AutoSpawnable = false
SWEP.HoldType = "slam"
SWEP.AdminSpawnable = true
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Kind = WEAPON_EQUIP2


if SERVER then
   resource.AddWorkshop("662342819")
   AddCSLuaFile( "shared.lua" )
   resource.AddFile("materials/VGUI/ttt/icon_randomat.vmt")
  util.AddNetworkString( "RandomatMessage" )
  function RandomatBroadcast(...)
    local msg = {...}
    net.Start("RandomatMessage")
    net.WriteTable(msg)
    net.Broadcast()
  end
end

if CLIENT then

   SWEP.PrintName    = "Randomat-3000"
   SWEP.Slot         = 7

   SWEP.ViewModelFOV  = 60
   SWEP.ViewModelFlip = false

   SWEP.Icon = "VGUI/ttt/icon_randomat"
      SWEP.EquipMenuData = {
      type = "weapon",
      desc = "The Randomat-3000 will do something Random! \nWho guessed that!"
   };
  net.Receive("RandomatMessage",function(len)
    local msg = net.ReadTable()
    chat.AddText(unpack(msg))
    chat.PlaySound()
  end)
end

SWEP.Primary.Delay       = 10
SWEP.Primary.Recoil      = 0
SWEP.Primary.Automatic   = false
SWEP.Primary.NumShots    = 1
SWEP.Primary.Damage      = 0
SWEP.Primary.Cone        = 0
SWEP.Primary.Ammo        = nil
SWEP.Primary.ClipSize    = -1
SWEP.Primary.ClipMax     = -1
SWEP.Primary.DefaultClip = -1
SWEP.AmmoEnt = nil

SWEP.InLoadoutFor = nil
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = true
SWEP.UseHands = true
SWEP.HeadshotMultiplier = 0
SWEP.CanBuy = { ROLE_DETECTIVE }
SWEP.LimitedStock = false
SWEP.Primary.Sound = ""

SWEP.ViewModel      = "models/weapons/gamefreak/c_csgo_c4.mdl"
SWEP.WorldModel      = "models/weapons/gamefreak/w_c4_planted.mdl"
SWEP.Weight = 2

function SWEP:OnRemove()
  if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
    RunConsoleCommand("lastinv")
  end
end

function SWEP:Initialize()
  util.PrecacheSound("weapons/c4_initiate.wav")
end

local NofalldamageRandomat = false
--local NodamageJackpot2 = false
local NoexplosiondamageRandomat = false
--local NodamageJackpot = false
--local OnlyHeadshots = false
local NoBulletdamageRandomat = false

function SWEP:PrimaryAttack()
  RandomEvent()
  DamageLog("RANDOMAT: " .. self.Owner:Nick() .. " [" .. self.Owner:GetRoleString() .. "] used his Randomat" )
  self:SetNextPrimaryFire(CurTime() * 10)
  self:Remove()
end

function RandomEvent()
local RandomEvents = {
  RandomatRoles,
  RandomatFalldamage,
  RandomatJump,
  RandomatHuge,
  RandomatSuddenDeath,
  RandomatFreeforAll,
  RandomatMoonGravity,
  RandomatDeathmatch,
  RandomatRandomHealth,
  RandomatRotate,
  RandomatSuperBlitz,
  RandomatBurn,
  RandomatFlash,
  RandomatModels,
  RandomatTitans,
  RandomatDisguise,
  RandomatSpeedLiveJump,
  RandomatExplode,
  RandomatExplosion,
  RandomatTime,
  RandomatRandomWeapons,
  RandomatBullet
}
RandomEvents[math.random(1,#RandomEvents)]()
end

/*function RandomatJackpot()
      NodamageJackpot = true
      NodamageJackpot2 = true
      RandomatBroadcast(Color(255,255,255), "Jackpot!(You should be happy now :D ) No more Explosion and Falldamage, 200 HP, higher Jumping more Speed and Low Gravity! And Tiny People and Knifes! What could be better?")
      for k,v in pairs(player.GetAll()) do
        v:SetModelScale( 0.5, 1 )
        v:SetHealth(200)
        v:SetJumpPower(320)
        v.RandomatJackpotSpeed = true
        v:Give("weapon_ttt_push")
        v:Give("weapon_ttt_knife")
        v:SetGravity(0.1)
      end
      hook.Add("EntityTakeDamage", "TTTRandomatJackpot", function(ent, dmginfo)
          if NodamageJackpot == true and IsValid(ent) and ent:IsPlayer() and dmginfo:IsFallDamage() then
            return true
          end
        end )
      hook.Add("EntityTakeDamage", "TTTRandomatJackpot2", function(ent, dmginfo)
          if NodamageJackpot2 == true and IsValid(ent) and ent:IsPlayer() and dmginfo:IsExplosionDamage() then
            return true
          end
        end )
      hook.Add("TTTPlayerSpeed", "RandomatTTTJackpotSpeed" , function(ply)
          if ply.RandomatJackpotSpeed == true then
            return 2
          end
        end )
      for key,ply in pairs(player.GetAll()) do
        for k,v in pairs(ply:GetWeapons()) do
          if v.Kind == WEAPON_HEAVY then
            ply:StripWeapon( v:GetClass() )
            ply:Give("weapon_zm_shotgun")
            timer.Simple( 0.1, function() ply:SelectWeapon("weapon_zm_shotgun") end )
          elseif v.Kind == WEAPON_PISTOL then
            ply:StripWeapon( v:GetClass() )
            ply:Give("weapon_zm_revolver")
          else
            ply:Give("weapon_zm_shotgun")
            ply:Give("weapon_zm_revolver")
            timer.Simple( 0.1, function() ply:SelectWeapon("weapon_zm_shotgun") end )
          end
        end
      end
end*/

/*function RandomatTinyRats()
    RandomatBroadcast(Color(255,255,255), "You wanne be tiny like rats? Now you are!")
    for k,v in pairs(player.GetAll()) do
        v:SetModelScale( 0.5, 1 )
    end
end*/

 /* function RandomatFreeWeapons()
  RandomatBroadcast(Color(255,255,255), "Free Weapons! You are not able to drop these weapons!")
  for key,ply in pairs(player.GetAll()) do
    for k,v in pairs(ply:GetWeapons()) do
      if v.Kind == WEAPON_HEAVY then
        ply:StripWeapon( v:GetClass() )
        ply:Give("weapon_zm_shotgun")
        timer.Simple( 0.1, function() ply:SelectWeapon("weapon_zm_shotgun") end )
      elseif v.Kind == WEAPON_PISTOL then
        ply:StripWeapon( v:GetClass() )
        ply:Give("weapon_zm_revolver")
      else
        ply:Give("weapon_zm_shotgun")
        ply:Give("weapon_zm_revolver")
        timer.Simple( 0.1, function() ply:SelectWeapon("weapon_zm_shotgun") end )
      end
    end
  end
  timer.Simple(0.2, function()
    for key,ply in pairs(player.GetAll()) do
      for k,v in pairs(ply:GetWeapons()) do
        if v.Kind == WEAPON_HEAVY or v.Kind == WEAPON_PISTOL then
          v.AllowDrop = false
        end
      end
    end
  end )
end */

/*function RandomatSecretWeapons()
  RandomatBroadcast(Color(255,255,255), "Show me your Secret Weapons my FRIEND 8) !")
  for key,ply in pairs(player.GetAll()) do
    for k,v in pairs(ply:GetWeapons()) do
      if v.Kind == WEAPON_EQUIP1 then
        ply:SelectWeapon( v:GetClass() )
      elseif v.Kind == WEAPON_EQUIP2 then
        ply:SelectWeapon( v:GetClass() )
      else
        ply:Give("weapon_ttt_knife")
        ply:SelectWeapon( "weapon_ttt_knife")
      end
    end
  end
end*/

/*function RandomatAmmo()
  RandomatBroadcast(Color(255,255,255), "WITH WHAT YOU WANT TO SHOOT NOW?")
  for key,ply in pairs(player.GetAll()) do
    for i, weapon in pairs(ply:GetWeapons()) do
      if (weapon.Primary.ClipSize != -1) and weapon.Kind == WEAPON_HEAVY then
        weapon:SetClip1(0)
      elseif (weapon.Primary.ClipSize != -1) and weapon.Kind == WEAPON_PISTOL then
        weapon:SetClip1(0)
      end
      if (weapon.Secondary.ClipSize != -1) and weapon.Kind == WEAPON_HEAVY then
        weapon:SetClip2(0)
      elseif (weapon.Secondary.ClipSize != -1) and weapon.Kind == WEAPON_PISTOL then
        weapon:SetClip2(0)
      end
    end
  end
end*/

/*function RandomatWeapons()
  RandomatBroadcast(Color(255,255,255), "Oh NO! Where are my Weapons D:!")
  for key,ply in pairs(player.GetAll()) do
    for k,v in pairs(ply:GetWeapons()) do
      if v.Kind == WEAPON_HEAVY or v.Kind == WEAPON_EQUIP1 or v.Kind == WEAPON_EQUIP2 or v.Kind == WEAPON_PISTOL or v.Kind == WEAPON_ROLE then
        ply:StripWeapon( v:GetClass() )
        timer.Simple( 0.1, function() ply:SelectWeapon("weapon_zm_improvised") end )
      end
    end
  end
end*/

/* function RandomatCamping()
  RandomatBroadcast(Color(255,255,255), "ONLY CAMPING 8) You are not able to drop these weapons!")
    for key,ply in pairs(player.GetAll()) do
      for k,v in pairs(ply:GetWeapons()) do
        if v.Kind == WEAPON_HEAVY then
          ply:StripWeapon( v:GetClass() )
          ply:Give("weapon_zm_rifle")
          timer.Simple( 0.1, function() ply:SelectWeapon("weapon_zm_rifle") end )
        elseif v.Kind == WEAPON_PISTOL then
          ply:StripWeapon( v:GetClass() )
          ply:Give("weapon_zm_revolver")
        else
          ply:Give("weapon_zm_rifle")
          ply:Give("weapon_zm_revolver")
          timer.Simple( 0.1, function() ply:SelectWeapon("weapon_zm_rifle") end )
        end
      end
    end
  timer.Simple(0.2, function()
    for key,ply in pairs(player.GetAll()) do
      for k,v in pairs(ply:GetWeapons()) do
      if v.Kind == WEAPON_HEAVY or v.Kind == WEAPON_PISTOL then
        v.AllowDrop = false
        end
      end
    end
  end )
end */

/*function RandomatRelaxed()
    RandomatBroadcast(Color(255,255,255), "Take it relaxed!")
    game.SetTimeScale(0.75)
    hook.Add("TTTPrepareRound", "RandomatSetTimescaleRelaxed", function()
    game.SetTimeScale(1)
    end )
end*/

function RandomatSpeedLiveJump()
    RandomatBroadcast("Randomat: ", Color(255,255,255), "50% More Speed, Jump Power and Live for everyone!")
    for k,v in pairs(player.GetAll()) do
      v:SetHealth(v:Health() * 1.5)
        v:SetJumpPower( v:GetJumpPower() + 80)
        v.RandomatSpeed = true
        if v:Health() < 50 then
          v:SetHealth(50)
        end
    end
  hook.Remove("TTTPlayerSpeed", "RandomatTTTSuperSpeed" )
  hook.Add("TTTPlayerSpeed", "RandomatTTTSpeed" , function(ply)
      if ply.RandomatSpeed == true and !ply.RandomatSuperSpeed then
      return 1.5
      end
  end )
end

function RandomatDeathmatch()
RandomatBroadcast("Randomat: ", Color(255,255,255), "Random Team Deathmatch!")
  local Players = player.GetAll()
  local PlayerNum = #Players
  local DetectiveNum = PlayerNum / 2

  for i = 1, PlayerNum do
    local Num = math.random(1, #Players)
    local Ply = Players[Num]

    if DetectiveNum > 0 then
      Ply:SetRole(ROLE_DETECTIVE)
      DetectiveNum = DetectiveNum - 1
    else
      Ply:SetRole(ROLE_TRAITOR)
    end
    Ply:SetDefaultCredits()
    table.remove(Players, Num)
  end
  SendFullStateUpdate()
end

function RandomatJump()
    RandomatBroadcast("Randomat: ", Color(255,255,255), "Jumping is fun, so a few people can now jump higher! And some others can´t jump at all.")
    for k,v in pairs(player.GetAll()) do
      v.randomatjump = math.random(1,2)
      if v.randomatjump == 1 then
        v:SetJumpPower(459)
      elseif v.randomatjump == 2 then
        v:SetJumpPower(0)
      end
    end
end

function RandomatHuge()
    RandomatBroadcast("Randomat: ", Color(255,255,255), "Let it SPRAY! You are not able to drop this weapon!")
    for key,ply in pairs(player.GetAll()) do
      for k,v in pairs(ply:GetWeapons()) do
        if v.Kind == WEAPON_HEAVY then
          ply:StripWeapon( v:GetClass() )
          ply:Give("weapon_zm_sledge")
          timer.Simple( 0.1, function() ply:SelectWeapon("weapon_zm_sledge") end )
        else
          ply:Give("weapon_zm_sledge")
          timer.Simple( 0.1, function() ply:SelectWeapon("weapon_zm_sledge") end )
        end
      end
    end
  timer.Simple(0.2, function()
    for key,ply in pairs(player.GetAll()) do
      for k,v in pairs(ply:GetWeapons()) do
        if v.Kind == WEAPON_HEAVY then
          v.AllowDrop = false
        end
      end
    end
  end )
end

function RandomatSuddenDeath()
  RandomatBroadcast("Randomat: ", Color(255,255,255), "Sudden DEATH!! AND NOBODY CAN HEAL!")
  for key,ply in pairs(player.GetAll()) do
    ply:SetHealth(1)
    ply:SetMaxHealth(1)
  end
  timer.Create("SuddenDeathHealRandomat", 1, 0, function()
    for k,v in pairs(player.GetAll()) do
      if v:Health() > 1 then
        v:SetHealth(1)
      end
    end
  end )
  hook.Add("TTTPrepareRound", "HookSuddenDeathRemove", function()
  timer.Remove("SuddenDeathHealRandomat")
  end)
end

function RandomatFreeforAll()
  RandomatBroadcast("Randomat: ", Color(255,255,255), "Free for all!")
  for key,ply in pairs(player.GetAll()) do
    if   ply:GetRole() == ROLE_TRAITOR then
      ply:GiveEquipmentItem(EQUIP_RADAR)
      ply:SendLua([[RunConsoleCommand("ttt_radar_scan")]])
      timer.Simple(0.01, function()
        ply:Give("weapon_ttt_knife")
        ply:Give("weapon_ttt_push")
      end )
    elseif ply:GetRole() == ROLE_DETECTIVE then
      ply:GiveEquipmentItem(EQUIP_RADAR)
      ply:SendLua([[RunConsoleCommand("ttt_radar_scan")]])
      timer.Simple(0.01, function()
        ply:Give("weapon_ttt_push")
        ply:Give("weapon_ttt_knife")
      end )
    elseif ply:GetRole() == ROLE_INNOCENT then
      timer.Simple(0.01, function()
      ply:Give("weapon_ttt_push")
      ply:Give("weapon_ttt_knife")
      end )
    end
  end
end

function RandomatMoonGravity()
  RandomatBroadcast("Randomat: ", Color(255,255,255), "What? Moon Gravity on Earth?")
  for key,ply in pairs(player.GetAll()) do
    ply:SetGravity(0.1)
  end
  timer.Create("RandomatGravity", 1, 0, function()
    for key,ply in pairs(player.GetAll()) do
      if ply:GetGravity(1) then
        ply:SetGravity(0.1)
      end
    end
  end )
end

function RandomatRotate()
  RandomatBroadcast("Randomat: ", Color(255,255,255), "Rotate in another way!")
  timer.Create( "RandomatRotate" , 5, 1000 , function ()
    for key,ply in pairs(player.GetAll()) do
      if ply:IsTerror() then
        ply:SetEyeAngles(ply:EyeAngles() + Angle(0,math.random(75,480),0))
      end
    end
  end )
  hook.Add("TTTPrepareRound", "RandomatHookRotate", function() timer.Remove("RandomatRotate") end)
end

function RandomatBurn()
  RandomatBroadcast("Randomat: ", Color(255,255,255), "Burn for the detectives my little friends, BURN FOR OUR LIFE!!")
  for key,ply in pairs(player.GetAll()) do
    if ply:GetRole() == ROLE_INNOCENT then
      ply:Ignite( math.random(1,5) )
    elseif ply:GetRole() == ROLE_TRAITOR then
      ply:Ignite( math.random(2,6) )
    elseif ply:GetRole() == ROLE_DETECTIVE then
      ply:SetHealth( ply:Health() + math.random(20,100))
    end
  end
end

function RandomatFlash()
  game.SetTimeScale(1.5)
  RandomatBroadcast("Randomat: ", Color(255,255,255), "Everything is as fast as Flash now!(50% faster)")
  hook.Add("TTTPrepareRound", "RandomatSetTimescale", function() game.SetTimeScale(1) end )
  hook.Add("TTTEndRound", "RandomatReset2", function() timer.Remove("RandomatTimescale") end )
  timer.Create("RandomatTimescale", 1, 0, function() if GetRoundState() == ROUND_ACTIVE then game.SetTimeScale(1.5) else timer.Remove("RandomatTimescale") end end )
end

function RandomatModels()
  RandomatBroadcast("Randomat: ", Color(255,255,255), "Watch the models whisly, they say the truth!(In 20 Seconds)")
  timer.Create("TTTRandomatModels", 10, 1, function()
    RandomatBroadcast("Randomat: ", Color(255,255,255), "The Models have been revealed!")
    for key,ply in pairs(player.GetAll()) do
      if ply:GetRole() == ROLE_INNOCENT then
        ply:SetModel("models/player/mossman.mdl")
      elseif ply:GetRole() == ROLE_TRAITOR then
        ply:SetModel("models/player/skeleton.mdl")
      elseif ply:GetRole() == ROLE_DETECTIVE then
        ply:SetModel("models/player/police.mdl")
      end
    end
  end )
end

function RandomatTitans()
  RandomatBroadcast("Randomat: ", Color(255,255,255), "The fight of the Titans!")
  for key,ply in pairs(player.GetAll()) do
    ply:SetHealth(300)
  end
end

function RandomatDisguise()
  RandomatBroadcast("Randomat: ", Color(255,255,255), "WHO IS WHO? I forgot sorry.")
  for key,ply in pairs(player.GetAll()) do
    ply:SetNWBool("disguised", true)
  end
end

function RandomatExplode()
  RandomatBroadcast("Randomat: ", Color(255,255,255), "A Random Person will explode in 30 seconds! Watch out!")
  local effectdata = EffectData()
  timer.Create("RandomatExplode", 30, 1, function()
    local aliveplayer = {}
      for k,v in pairs(player.GetAll()) do
      if v:IsTerror() then table.insert(aliveplayer,v) end
    end
    local randomply = aliveplayer[math.random(#aliveplayer)]
    RandomatBroadcast("Randomat: ", Color(255,255,255), randomply:Nick() .. " exploded!")
    randomply:EmitSound( Sound ("ambient/explosions/explode_4.wav") )
    util.BlastDamage( randomply, randomply, randomply:GetPos() , 300 , 10000 )
    effectdata:SetStart( randomply:GetPos() + Vector(0,0,10) )
    effectdata:SetOrigin( randomply:GetPos() + Vector(0,0,10) )
    effectdata:SetScale( 1 )
    util.Effect( "HelicopterMegaBomb", effectdata )
  end )
  hook.Add("TTTPrepareRound", "TTTRandomatExplode", function() timer.Remove("RandomatExplode") end)
  hook.Add("TTTEndRound", "TTTRandomatExplode", function() timer.Remove("RandomatExplode") end)
end



function RandomatTime()
  RandomatBroadcast("Randomat: ", Color(255,255,255), "Healing for u!")
  timer.Create("RandomatLive",1,0, function()
    for k,v in pairs(player.GetAll()) do
      v:SetHealth(v:Health() + 1)
    end
  end )
  hook.Add("TTTEndRound", "RandomatHookLive", function() timer.Remove("RandomatLive") end)
end

function RandomatRandomWeapons()
  RandomatBroadcast("Randomat: ", Color(255,255,255), "Random Weapons for everyone!")
  for key,v in pairs(player.GetAll()) do
    for k, weapon in pairs(v:GetWeapons()) do
      if weapon.Kind == WEAPON_HEAVY or weapon.Kind == WEAPON_PISTOL then
        v:StripWeapon(weapon:GetClass())
      end
    end
  end
  timer.Create("RandomItems", 0.01, 100, function()
    for key,p in pairs(player.GetAll()) do
      local randomweapon = table.Random(weapons.GetList())
      if randomweapon.AutoSpawnable and randomweapon.Kind == WEAPON_HEAVY or randomweapon.Kind == WEAPON_PISTOL then
        p:Give(randomweapon.ClassName)
      end
    end
  end )
end

function RandomatBullet()
    RandomatBroadcast("Randomat: ", Color(255,255,255), "Only Weapons allowed!")
    NoBulletdamageRandomat = true
    hook.Add("EntityTakeDamage", "TTTRandomatBullet", function(ent, dmginfo)
      if IsValid(ent) and ent:IsPlayer() and !dmginfo:IsBulletDamage() and !dmginfo:GetDamageType(DMG_FALL) and NoBulletdamageRandomat == true then
        return true
      end
    end)
end

function RandomatSuperBlitz()
  RandomatBroadcast("Randomat: ", Color(255,255,255), "TTT-SuperBlitz, 400% More Speed!")
    for k,v in pairs(player.GetAll()) do
      v.RandomatSuperSpeed = true
    end
  hook.Remove("TTTPlayerSpeed", "RandomatTTTSpeed" )
  hook.Add("TTTPlayerSpeed", "RandomatTTTSuperSpeed" , function(p)
    if p.RandomatSuperSpeed == true then
      return 4
    end
  end )
end

function RandomatFalldamage()
    RandomatBroadcast("Randomat: ", Color(255,255,255), "No more Falldamage!")
    NofalldamageRandomat = true
    hook.Add("EntityTakeDamage", "TTTRandomatFall", function(ent, dmginfo)
      if IsValid(ent) and ent:IsPlayer() and dmginfo:IsFallDamage() and NofalldamageRandomat == true then
        return true
      end
    end)
end

function RandomatExplosion()
    RandomatBroadcast("Randomat: ", Color(255,255,255), "No more Explosion Damage!")
    NoexplosiondamageRandomat = true
    hook.Add("EntityTakeDamage", "TTTRandomatExplode2", function(ent, dmginfo)
      if IsValid(ent) and ent:IsPlayer() and dmginfo:IsExplosionDamage() and NoexplosiondamageRandomat == true then
        return true
      end
    end)
end

function RandomatRandomHealth()
    RandomatBroadcast("Randomat: ", Color(255,255,255),"Random Health for everyone!")
    for k,v in pairs(player.GetAll()) do
      v:SetHealth( v:Health() + math.random(1,100) )
    end
end

function RandomatRoles()
    RandomatBroadcast("Randomat: ", Color(255,255,255), "ROLE SHUFFLE!")
    SelectRoles()
    SendFullStateUpdate()
end

function ResettinRandomat()
    NoexplosiondamageRandomat = false
    NofalldamageRandomat = false
    OnlyRandomatHeadshots = false
    NodamageJackpot = false
    NodamageJackpot2 = false
    NoBulletdamageRandomat  = false
      for k,v in pairs(player.GetAll()) do
        v.RandomatSuperSpeed = false
        v:SetGravity(1)
        v:SetModelScale( 1, 1 )
        v.RandomatSpeed = false
        v:SetJumpPower(160)
      end
    timer.Remove("RandomItems")
    timer.Remove("RandomatOneShot")
    timer.Remove("RandomatLive")
    timer.Remove("TTTRandomatModels")
    timer.Remove("RandomatGravity")
    timer.Remove("RandomatTimescale")
    hook.Remove("")
    hook.Remove("")
    hook.Remove("")
    hook.Remove("")
    hook.Remove("")
    hook.Remove("")
    hook.Remove("")
    hook.Remove("")
    hook.Remove("EntityTakeDamage", "TTTRandomatBullet")
    hook.Remove("TTTPlayerSpeed", "RandomatTTTSpeed")
    hook.Remove("TTTPlayerSpeed", "RandomatTTTSuperSpeed")
    hook.Remove("EntityTakeDamage", "TTTRandomatFall")
    hook.Remove("EntityTakeDamage", "TTTRandomatExplode2")
end


if CLIENT then
  function SWEP:PrimaryAttack()
    surface.PlaySound("weapons/c4_initiate.wav")
  end
end

hook.Add("TTTPrepareRound", "RandomatReset", ResettinRandomat )