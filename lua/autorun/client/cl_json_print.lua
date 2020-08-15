net.Receive("json_print", function()
	local bytes = util.JSONToTable(net.ReadString())
	chat.AddText(bytes[1] or Color(50,255,255), bytes[2], Color(255,255,255), bytes[3])
end)

net.Receive('ix_JsonPrint', function()
	local bytes = util.JSONToTable(net.ReadString())
	chat.AddText(bytes[2] .. ' | ' .. bytes[1])
end)
