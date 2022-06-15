//Lots of debug :)
if GetConVar("tts_debug"):GetBool() then
	MsgC(Color( 255, 0, 255 ),"Loaded sv_tts_sandbox.lua\n")
end

function say(ply, text, table)
	//debug
	if GetConVar("tts_debug"):GetBool() then
		if GetConVar("tts_admin_only"):GetBool() and not ply:IsAdmin() then
			MsgC(Color( 255, 0, 255 ),"TTS is admin only and ply " .. ply:Nick() .. " is not admin.\n")
		end
	end

	//if tts is admin only and ply is not admin return
	if GetConVar("tts_admin_only"):GetBool() and not ply:IsAdmin() then return end

	//debug
	if GetConVar("tts_debug"):GetBool() then
		if not table and GetConVar("tts_prefix"):GetString() and not string.StartWith(text, GetConVar("tts_prefix"):GetString()) or table and GetConVar("tts_prefix"):GetString() and not string.StartWith(text[1], GetConVar("tts_prefix"):GetString()) then
			MsgC(Color( 255, 0, 255 ),"TTS has a prefix and the text [" .. text .. "] does not start with it.\n")
		end
	end

	//if there is a prefix and the text does not start with it, return
	if not table and GetConVar("tts_prefix"):GetString() and not string.StartWith(text, GetConVar("tts_prefix"):GetString()) then return end
	if table and GetConVar("tts_prefix"):GetString() and not string.StartWith(text[1], GetConVar("tts_prefix"):GetString()) then return end

	//debug
	if GetConVar("tts_debug"):GetBool() then
		MsgC(Color( 255, 0, 255 ),"Sending net message: ent: " .. ply:Nick() .. " text: " .. text .. "\n")
	end

	if GetConVar("tts_prefix"):GetString() then
		//remove prefix from text
		if not table then
        	text = string.sub( text, #GetConVar("tts_prefix"):GetString() + 1)
		else
			text[1] = string.sub( text[1], #GetConVar("tts_prefix"):GetString() + 1)
		end

		//debug
		if GetConVar("tts_debug"):GetBool() then
			MsgC(Color( 255, 0, 255 ),"TTS Made new string: " .. text .. ".\n")
		end
	end

	if GetConVar("tts_say_name"):GetBool() then
		//add name to text ex: "PlayerName said: Text"
		if not table then
        	text = ply:Nick() .. "Said. " .. text
		else
			//for every entry in the table add the name to the text
			for k, v in pairs(text) do
				text[k] = ply:Nick() .. "Said. " .. v
			end
		end

		//debug
		if GetConVar("tts_debug"):GetBool() then
			MsgC(Color( 255, 0, 255 ),"TTS Made new string: " .. text .. ".\n")
		end
	end

	local global = 0

	local TEAM_SPECTATOR = 1002

    for k, v in ipairs(player.GetAll()) do

        //if recieving player is dead return end
		if not v:IsValid() then return end

		if GetConVar("tts_debug"):GetBool() then
			if GetConVar("tts_specdm"):GetBool() then
				if v:IsGhost() then
					MsgC(Color( 0, 255, 0 ),"Player " .. v:Nick() .. " is a ghost.\n")
				else
					MsgC(Color( 255, 0, 0 ),"Player " .. v:Nick() .. " is not a ghost.\n")
				end
			else
				MsgC(Color( 255, 0, 255 ),"TTS Specdm support is not enabled\n")
			end

			if GetConVar("tts_birds_eye_view"):GetBool() then
				if v:IsBirdView() then 
					MsgC(Color( 0, 255, 0 ),"Player " .. v:Nick() .. " is a bird.\n")
				else
					MsgC(Color( 255, 0, 0 ),"Player " .. v:Nick() .. " is not a bird.\n")
				end
			else
				MsgC(Color( 255, 0, 255 ),"TTS birds eye view support is now enabled\n")
			end

			if v:Team() == TEAM_SPECTATOR then
				MsgC(Color( 0, 255, 0 ),"Player " .. v:Nick() .. " is a spectator.\n")
			else
				MsgC(Color( 255, 0, 0 ),"Player " .. v:Nick() .. " is not a spectator. They are a " .. v:Team() .. "\n")
			end

			if v:Alive() then
				MsgC(Color( 0, 255, 0 ),"Player " .. v:Nick() .. " is alive.\n")
			else
				MsgC(Color( 255, 0, 0 ),"Player " .. v:Nick() .. " is dead.\n")
			end
		end

		//if the round is active 
        if GetRoundState() == ROUND_ACTIVE then
			//add more debug
			if GetConVar("tts_debug"):GetBool() then
				MsgC(Color( 0, 255, 0 ),"TTS Round is active.\n")
			else 
				MsgC(Color( 255, 0, 0 ),"TTS Round is active.\n")
			end

            //if recieving player is alive but sending player is not the return end
            if not ply:Alive() and v:Alive() then return end

			//if sending player is a spectator and recieving player is not a spectator return end
			if ply:Team() == TEAM_SPECTATOR and not v:Team() == TEAM_SPECTATOR then return end

            if GetConVar("tts_specdm"):GetBool() then
                //if sending player is a ghost but the recieving player is not return end
                if ply:IsGhost() and not v:IsGhost() then return end
            end

            if GetConVar("tts_birds_eye_view"):GetBool() then
                //if sending player is a ghost but the recieving player is not return end
                if ply:IsBirdView() and not ( v:IsBirdView() or not v:Team() == TEAM_SPECTATOR ) then return end
            end

        end

		//add more debug
		if GetConVar("tts_debug"):GetBool() then
			MsgC(Color( 255, 0, 255 ),"TTS Sending to: " .. v:Nick() .. " text: " .. text .. "\n")
		end

		//Send the message to the player
        net.Start("tts")
            net.WriteEntity(ply)
            net.WriteString(text)
            net.WriteBool(global)
        net.Send(v)
    end
end

hook.Add("PlayerSay", "mba_tts", function(ply, text)

	//if tts is not enabled return
	if not GetConVar("tts_enable"):GetBool() then return end

	//debug
	if GetConVar("tts_debug"):GetBool() then
		if not GetConVar("tts_enable"):GetBool() then
			MsgC(Color( 255, 0, 255 ),"TTS is not enabled\n")
		end
	end

	//Max length of api 1024
	//if text is longer than 1024 split it up
	function split(text)
		local t = {}
		local i = 1
		local j = 1
		while i <= #text do
			if j > 1024 then
				t[#t+1] = string.sub(text, i, i+1023)
				i = i + 1023
				j = 1
			else
				t[#t+1] = string.sub(text, i, i)
				i = i + 1
				j = j + 1
			end
		end

		if GetConVar("tts_debug"):GetBool() then
			if not GetConVar("tts_enable"):GetBool() then
				MsgC(Color( 255, 0, 255 ),"TTS split message into " .. #t .. " parts.\n")
				MsgC(Color( 255, 0, 255 ),"TTS " .. t .. "\n")
			end
		end

		return t
	end

	if string.len(text) > 1024 then
		if GetConVar("tts_debug"):GetBool() then
			if not GetConVar("tts_enable"):GetBool() then
				MsgC(Color( 21, 255, 0),"TTS cant handle that much text\n")
			end
		end

		say(ply, split(text), true)
	else
		
		say(ply, text, false)
	end
end)