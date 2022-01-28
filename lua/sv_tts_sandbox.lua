//Lots of debug :)
if GetConVar("tts_debug"):GetBool() then
	MsgC(Color( 255, 0, 255 ),"Loaded sv_tts_sandbox.lua\n")
end

hook.Add("PlayerSay", "mba_tts", function(ply, text)

	if GetConVar("tts_debug"):GetBool() then
		if not GetConVar("tts_enable"):GetBool() then
			MsgC(Color( 255, 0, 255 ),"TTS is not enabled\n")
		end
	end

	//Max length of api 1024
	if string.len(text) > 1024 then
		if GetConVar("tts_debug"):GetBool() then
			if not GetConVar("tts_enable"):GetBool() then
				MsgC(Color( 255, 0, 255 ),"TTS cant handle that much text\n")
			end
		end

		timer.Simple(0.1, function()
			ply:SendLua([[chat.AddText( "TTS: Mesasge is too long!" )]])
		end)
		return
	end

	if not GetConVar("tts_enable"):GetBool() then return end

	if GetConVar("tts_debug"):GetBool() then
		if GetConVar("tts_admin_only"):GetBool() and not ply:IsAdmin() then
			MsgC(Color( 255, 0, 255 ),"TTS is admin only and ply " .. ply:Nick() .. " is not admin.\n")
		end
	end

	if GetConVar("tts_admin_only"):GetBool() and not ply:IsAdmin() then return end

	if GetConVar("tts_debug"):GetBool() then
		if GetConVar("tts_prefix"):GetString() and not string.StartWith(text, GetConVar("tts_prefix"):GetString()) then
			MsgC(Color( 255, 0, 255 ),"TTS has a prefix and the text [" .. text .. "] does not start with it.\n")
		end
	end

	if GetConVar("tts_prefix"):GetString() and not string.StartWith(text, GetConVar("tts_prefix"):GetString()) then return end

	if GetConVar("tts_debug"):GetBool() then
		MsgC(Color( 255, 0, 255 ),"Sending net message: ent: " .. ply:Nick() .. " text: " .. text .. "\n")
	end

	if GetConVar("tts_prefix"):GetString() then
        text = string.sub( text, #GetConVar("tts_prefix"):GetString() + 1)
		if GetConVar("tts_debug"):GetBool() then
			MsgC(Color( 255, 0, 255 ),"TTS Made new string: " .. text .. ".\n")
		end
	end

	if GetConVar("tts_say_name"):GetBool() then
        text = ply:Nick() .. "Said. " .. text
		if GetConVar("tts_debug"):GetBool() then
			MsgC(Color( 255, 0, 255 ),"TTS Made new string: " .. text .. ".\n")
		end
	end

	local global = 0

	net.Start("tts")
		net.WriteEntity(ply)
		net.WriteString(text)
		net.WriteBool(global)
	net.Broadcast()

end)