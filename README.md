# gmod-tts
 Moon base alpha tts for gmod
 
# Adding Gamemode Support
 Currently the tts only supports sandbox and murder but what if you it doesn't support yours or you want it to act differently here is how to do it.
 When a message is sent the tts calls a hook on the server. If the hook responds with tts = true then it sends the table to the client where another hook is called if the server and the client say its ok then the message is played. The hooks are stored in a file with the name of the gamemode in the gamemodes folder. If you do it right you shouldnt need to modify the tts code. The hooks dont need to be in the file but its recommended. With the info provided on the server and the client in the hooks you should be able to add support for anything.
 
 I'm not good at explaining this. If you can code you will get whats below.
 
```
if SERVER then
	if GetConVar("tts_debug"):GetBool() then MsgC(Color( 255, 0, 255 ),"Loaded tts/gamemodes/" .. string.lower(engine.ActiveGamemode()) .. ".lua\n") end

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

		return table
	end)
end
```
