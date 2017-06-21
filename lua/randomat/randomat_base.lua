Randomat.Events = Randomat.Events or {}
Randomat.MapEvents = Randomat.MapEvents or {}
Randomat.ActiveEvents = {}

local randomat_meta =  {}
randomat_meta.__index = randomat_meta

local function shuffleTable(t)
	math.randomseed(os.time())
	local rand = math.random

	local interactions = #t
	local j

	for i = interactions, 2, -1 do
		j = rand(i)
		t[i], t[j] = t[j], t[i]
	end
end

local function eventIndex()
	math.randomseed(os.time())
	local length = math.random(1, 10)

	if length < 1 then return end

	local result = ""

	for i = 1, length do
		result = result .. string.char(math.random(32, 126))
	end

	return result
end

function Randomat:register(id, tbl)
	if Randomat.Events[id] then error("EVENT of name '" .. id .. "' already exists!") return end
	tbl.Id = id
	tbl.__index = tbl
	setmetatable(tbl, randomat_meta)

	Randomat.Events[id] = tbl
end

function Randomat:exists(id)
	return Randomat.Events[id] ~= nil
end

if SERVER then
	util.AddNetworkString("randomat_message")
	util.AddNetworkString("randomat_clevent")

	function Randomat:TriggerRandomEvent(ply)
		if table.Count(Randomat.MapEvents) == 0 then Randomat.MapEvents = table.Copy(Randomat.Events) end
		local events = Randomat.MapEvents
		local index = eventIndex()

		shuffleTable(events)

		local event = table.Random(events)

		Randomat.ActiveEvents[index] = event
		Randomat.ActiveEvents[index].Ident = index
		Randomat.ActiveEvents[index].Owner = ply

		net.Start("randomat_clevent")
		net.WriteString(Randomat.ActiveEvents[index].Id)
		net.WriteString(index)
		net.Broadcast()
	
		Randomat:EventNotify(Randomat.ActiveEvents[index].Title)

		if Randomat.ActiveEvents[index]:Begin() ~= nil then -- Hinzugefügt auf grund der Clientside Events
			Randomat.ActiveEvents[index]:Begin()
		end

		if Randomat.ActiveEvents[index].Time ~= nil then
			timer.Create("Randomat" .. Randomat.ActiveEvents[index].Ident, Randomat.ActiveEvents[index].Time or 60, 1, function()
				Randomat.ActiveEvents[index]:End()
				Randomat.ActiveEvents[index]:SmallNotify("The '" .. Randomat.ActiveEvents[index].Title .. "' Event has ended.")
				Randomat.ActiveEvents[index] = nil
			end)
		end

		Randomat.MapEvents[event.Id] = nil
	end
	
	function Randomat:EventNotify(title)
		net.Start("randomat_message")
		net.WriteBool(true)
		net.WriteString(title)
		net.WriteUInt(0, 8)
		net.Broadcast()
	end
end

if CLIENT then
	net.Receive("randomat_clevent", function()
		local id = net.ReadString()
		local index = net.ReadString()
	
		if not Randomat:exists(id) then
			return
		end

		Randomat.ActiveEvents[index] = Randomat.Events[id]
		Randomat.ActiveEvents[index].Ident = index

		Randomat.ActiveEvents[index]:Begin()

		if Randomat.ActiveEvents[index].Time ~= nil then
			timer.Create("Randomat" .. Randomat.ActiveEvents[index].Ident, Randomat.ActiveEvents[index].Time or 60, 1, function()
				Randomat.ActiveEvents[index]:End()
				CLEventNotify("The '" .. Randomat.ActiveEvents[index].Title .. "' Event has ended.", false)
				Randomat.ActiveEvents[index] = nil
			end)
		end
	end)
end

/**
 * Randomat Meta
 */

-- Valid players not spec
function randomat_meta:GetPlayers(shuffle)
	return self:GetAlivePlayers(shuffle)
end

/*function randomat_meta:AddNetworkString(str)
	util.AddNetworkString("RandomatEvent" .. self.Id .. str)
end

function randomat_meta:ReveiceNet(str)

end*/

function randomat_meta:GetAlivePlayers(shuffle)
	local plys = {}

	for _, ply in pairs(player.GetAll()) do
		if IsValid(ply) and (not ply:IsSpec()) and ply:Alive() then
			table.insert(plys, ply)
		end
	end

	if shuffle then
		shuffleTable(plys)
	end

	return plys
end

if SERVER then
	function randomat_meta:SmallNotify(msg, length, targ)
		if not isnumber(length) then length = 0 end
		net.Start("randomat_message")
		net.WriteBool(false)
		net.WriteString(msg)
		net.WriteUInt(length, 8)
		if not targ then net.Broadcast() else net.Send(targ) end
	end
end

function randomat_meta:AddHook(hooktype, callbackfunc)
	callbackfunc = callbackfunc or self[hooktype]

	hook.Add(hooktype, "RandomatEvent." .. self.Ident .. "." .. self.Id .. ":" .. hooktype, function(...)
		return callbackfunc(...)
	end)

	self.Hooks = self.Hooks or {}

	table.insert(self.Hooks, {hooktype, "RandomatEvent." .. self.Ident .. "." .. self.Id .. ":" .. hooktype})
end

function randomat_meta:CleanUpHooks()
	if not self.Hooks then return end

	for _, ahook in pairs(self.Hooks) do
		hook.Remove(ahook[1], ahook[2])
	end

	table.Empty(self.Hooks)
end

function randomat_meta:Begin() end

function randomat_meta:End()
	self:CleanUpHooks()
end


/*
 * Override TTT Stuff
 */
hook.Add("TTTEndRound", "RandomatEndRound", function()
	if Randomat.ActiveEvents ~= {} then
		for _, evt in pairs(Randomat.ActiveEvents) do
			timer.Remove("Randomat" .. evt.Ident)
			evt:End()
		end

		Randomat.ActiveEvents = {}
	end
end)

hook.Add("TTTPrepareRound", "RandomatEndRound", function()
	if Randomat.ActiveEvents ~= {} then
		for _, evt in pairs(Randomat.ActiveEvents) do
			timer.Remove("Randomat" .. evt.Ident)
			evt:End()
		end

		Randomat.ActiveEvents = {}
	end
end)
