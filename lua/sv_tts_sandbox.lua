//Lots of debug :)

hook.Add("PlayerSay", "mba_tts", function(ply, text)

	if debug:GetBool() then
		if not enable:GetBool() then
			MsgC(Color( 255, 0, 255 ),"TTS is not enabled")
		end
	end

	//Max length of api 1024
	if string.len(text) > 1024 then
		if debug:GetBool() then
			if not enable:GetBool() then
				MsgC(Color( 255, 0, 255 ),"TTS cant handle that much text")
			end
		end

		timer.Simple(0.1, function()
			ply:SendLua([[chat.AddText( "TTS: Mesasge is too long!" )]])
		end)
		return
	end

	if not enable:GetBool() then return end

	if debug:GetBool() then
		if adminOnly:GetBool() and not ply:IsAdmin() then
			MsgC(Color( 255, 0, 255 ),"TTS is admin only and ply " .. ply:Nick() .. " is not admin.")
		end
	end

	if adminOnly:GetBool() and not ply:IsAdmin() then return end

	if debug:GetBool() then
		if prefix:GetString() and not string.StartWith(text, prefix:GetString()) then
			MsgC(Color( 255, 0, 255 ),"TTS has a prefix and the text [" .. text .. "] does not start with it.")
		end
	end

	if prefix:GetString() and not string.StartWith(text, prefix:GetString()) then return end

	if debug:GetBool() then
		MsgC(Color( 255, 0, 255 ),"Sending net message: ent: " .. ply:Nick() .. " text: " .. text)
	end

	if prefix:GetString() then
        text = string.sub( text, #prefix:GetString() + 1)
		if debug:GetBool() then
			MsgC(Color( 255, 0, 255 ),"TTS Made new string: " .. text .. ".")
		end
	end

	if sayName:GetBool() then
        text = ply:Nick() .. "Said. " .. text
		if debug:GetBool() then
			MsgC(Color( 255, 0, 255 ),"TTS Made new string: " .. text .. ".")
		end
	end

	local global = 0

	net.Start("tts")
		net.WriteEntity(ply)
		net.WriteString(text)
		net.WriteInt(global)
	net.Broadcast()

end)