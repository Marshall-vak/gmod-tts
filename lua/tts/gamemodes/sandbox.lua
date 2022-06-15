if SERVER then
	if GetConVar("tts_debug"):GetBool() then MsgC(Color( 255, 0, 255 ),"Loaded tts/gamemodes/sandbox.lua\n") end

	//if the server says its ok then send it to the client
	hook.Add("preTTS", "sandbox", function(ply, text, team)
        if GetConVar("tts_debug"):GetBool() then MsgC(Color( 255, 0, 255 ),"preTTS Hook Called\n") end

		local table = {}
		
		table.tts = true
		table.ply = ply
		table.text = text
		table.global = tts.globalForce:GetBool()
		table.team = team

		if not IsValid(ply) then table.tts = false end

		return table
	end)
else
	//if the client says its ok then play it
	hook.Add("postTTS", "sandbox", function(serverTable)
        if GetConVar("tts_debug"):GetBool() then MsgC(Color( 255, 0, 255 ),"postTTS Hook called\n") end

		local table = {}
		
		table.tts = true
		table.ply = serverTable.ply
		table.text = serverTable.text
		table.global = serverTable.global
		table.team = serverTable.team

		if not IsValid(serverTable.ply) then table.tts = false end

		return table
	end)
end