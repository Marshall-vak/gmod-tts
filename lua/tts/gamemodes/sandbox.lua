if SERVER then
	//Lots of debug :)
	if GetConVar("tts_debug"):GetBool() then
		MsgC(Color( 255, 0, 255 ),"Loaded sv_tts_sandbox.lua\n")
	end

	//if the server says its ok then send it to the client
	hook.Add("preTTS", "sandbox", function(ply, text)
		local table = {}
		
		table.tts = true
		table.ply = ply
		table.text = text
		table.global = tts.globalForce:GetBool()

		if not IsValid(ply) then table.tts = false end

		return table
	end)
else
	//if the client says its ok then play it
	hook.Add("postTTS", "sandbox", function(serverTable)
		local table = {}
		
		table.tts = serverTable.tts
		table.ply = serverTable.ply
		table.text = serverTable.text
		table.global = serverTable.global

		if not IsValid(ply) then table.tts = false end

		return table
	end)
end