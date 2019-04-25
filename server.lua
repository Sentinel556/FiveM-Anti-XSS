local maxClients = GetConvarInt('sv_maxclients', 32)

local function inputSafe(str)
	if string.find(str, "script") or string.find(str, "http") then
		return fasle
	else
		return true
	end
end

local function logPlayer(name, ids)
	local string = "Logged User -> "..name..", IDs: "ids.."."
	local file = io.open('resources/'.. GetCurrentResourceName() .. '/Logs/log.txt', "a")
	print(string)
	io.output(file)
	io.write(string)
	io.close(file)
end

local function OnPlayerConnecting(name, setKickReason, deferrals)
	if GetNumPlayerIndices() < maxClients then
		deferrals.defer()
		local identifiers = GetPlayerIdentifiers(source)
		local cname = string.gsub(name, "%s+", "")
		deferrals.update(string.format("Hello %s. Your name is being checked.", name))

		if not inputSafe(cname) then
			local ids = ''
			for _, v in pairs(identifiers) do
				local ids = ids..' '..v
			end
			
			logPlayer(name, ids)
			deferrals.done("Your username seems to be fishy...")
		else
			deferrals.done()
		end
	end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)

AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end

	if not WasEventCanceled() and not inputSafe(author) or not inputSafe(message) then
		local identifiers = GetPlayerIdentifiers(source)
			
		local ids = ''
		for _, v in pairs(identifiers) do
			local ids = ids..' '..v
		end

		logPlayer(name, ids)
		return
	end
end)
