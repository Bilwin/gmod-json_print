util.AddNetworkString("json_print")

local function addText(col, str1, ply, str)
	local bytes = util.TableToJSON({col, str1, str})
	net.Start("json_print")
		net.WriteString(bytes)
	net.Send(ply)
end

local function recType(input)
	if isstring(input) then
		local output = {}

		for k, v in pairs(player.GetAll()) do
			if v:GetUserGroup() == input then
				output[v] = true
			end
		end

		return output
	elseif input.IsPlayer and input:IsPlayer() then
		local output = {}

		output[input] = true
		return output
	end

	return false
end

function json_print(col, str1, rec, str)
	if istable(rec) then
		local rec2 = {}

		for k, v in pairs(rec) do
			local rec = recType(v)

			if istable(rec) then
				for k in pairs(rec) do
					rec2[k] = true
				end
			elseif rec then
				rec2[rec] = true
			end
		end

		for k, v in pairs(rec2) do
			addText(col, str1, k, str)
		end
	elseif isstring(rec) then
		rec = recType(rec)

		for k, v in pairs(rec) do
			addText(col, str1, k, str)
		end
	elseif IsEntity(rec) and rec:IsPlayer() then
		addText(col, str1, rec, str)
	elseif rec then
		for k, v in pairs(player.GetAll()) do
			addText(col, str1, v, str)
		end
	end
end

-- extended
util.AddNetworkString("ix_JsonPrint")

function ix_SendMessage(client, mtype, text)
	local mtype_2 = ''
	
	if mtype == 1 then
		mtype_2 = '[WARNING]'
	elseif mtype == 2 then
		mtype_2 = '[NOTICE]'
	elseif mtype == 3 then
		mtype_2 = '[FATAL]'
	else
		mtype_2 = '[ERROR]'
	end
	
	local message = {
		['text'] = tostring(text),
		['type'] = mtype_2
	}
	
	local message_json = util.TableToJSON(message)
	
	if tostring(client) == 'all' then
		for _, v in ipairs(player.GetHumans()) do
			net.Start('ix_JsonPrint')
				net.WriteString(message_json)
			net.Send(v)
		end
	else
		net.Start('ix_JsonPrint')
			net.WriteString(message_json)
		net.Send(client)
	end
end
