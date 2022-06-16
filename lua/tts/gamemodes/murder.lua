if SERVER then
	if GetConVar("tts_debug"):GetBool() then MsgC(Color( 255, 0, 255 ),"Loaded tts/gamemodes/" .. string.lower(engine.ActiveGamemode()) .. ".lua\n") end

    //I hate this
    hook.Add("Think", "Fuck-tis-is-stupid-but-I-have-to", function() 
        for k,v in pairs(player.GetAll()) do
            if v:IsCSpectating() then
                v:SetNWBool("tts_is_spectating", true)
            else
                v:SetNWBool("tts_is_spectating", false)
            end
        end
    end)

	//if the server says its ok then send it to the client
	hook.Add("preTTS", string.lower(engine.ActiveGamemode()), function(ply, text, team)
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
	hook.Add("postTTS", string.lower(engine.ActiveGamemode()), function(serverTable)
        if GetConVar("tts_debug"):GetBool() then MsgC(Color( 255, 0, 255 ),"postTTS Hook called\n") end

		local table = {}
		
		table.tts = true
		table.ply = serverTable.ply
		table.text = serverTable.text
		table.global = serverTable.global
        table.team = serverTable.team

		if not IsValid(serverTable.ply) then table.tts = false end

        if table.ply:IsPlayer() and ( table.ply:GetNWBool("tts_is_spectating") and not LocalPlayer():GetNWBool("tts_is_spectating") ) then table.tts = false end

		return table
	end)
end