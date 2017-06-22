Randomat = Randomat or {}

local function AddServer(fil)
	if SERVER then include(fil) end
end

local function AddClient(fil)
	if SERVER then AddCSLuaFile(fil) end
	if CLIENT then include(fil) end
end

local function AddShared(fil)
	AddServer(fil)
	AddClient(fil)
end


AddShared("randomat/randomat_base.lua")
AddClient("randomat/cl_message.lua")
AddClient("randomat/cl_networkstrings.lua")

local files, _ = file.Find("randomat/events/*.lua", "LUA")

for _, fil in pairs(files) do
	local is_cl = fil:match("_cl%.lua") ~= nil

	if is_cl then
		AddClient("randomat/events/" .. fil)
	else
		AddServer("randomat/events/" .. fil)
	end
end
