net.Receive("json_print", function()
	local bytes = util.JSONToTable(net.ReadString())
	chat.AddText(bytes[1] or Color(50,255,255), bytes[2], Color(255,255,255), bytes[3])
end)
