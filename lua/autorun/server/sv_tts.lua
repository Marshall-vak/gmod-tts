//yes I know the ascii is almost the whole file but thats the point lol
MsgC(Color( 255, 0, 255 ),[[
$$\      $$\                                  $$$$$$$\                                    $$$$$$\ $$\         $$\                
$$$\    $$$ |                                 $$  __$$\                                  $$  __$$\$$ |        $$ |               
$$$$\  $$$$ |$$$$$$\  $$$$$$\ $$$$$$$\        $$ |  $$ |$$$$$$\  $$$$$$$\ $$$$$$\        $$ /  $$ $$ |$$$$$$\ $$$$$$$\  $$$$$$\  
$$\$$\$$ $$ $$  __$$\$$  __$$\$$  __$$\       $$$$$$$\ |\____$$\$$  _____$$  __$$\       $$$$$$$$ $$ $$  __$$\$$  __$$\ \____$$\ 
$$ \$$$  $$ $$ /  $$ $$ /  $$ $$ |  $$ |      $$  __$$\ $$$$$$$ \$$$$$$\ $$$$$$$$ |      $$  __$$ $$ $$ /  $$ $$ |  $$ |$$$$$$$ |
$$ |\$  /$$ $$ |  $$ $$ |  $$ $$ |  $$ |      $$ |  $$ $$  __$$ |\____$$\$$   ____|      $$ |  $$ $$ $$ |  $$ $$ |  $$ $$  __$$ |
$$ | \_/ $$ \$$$$$$  \$$$$$$  $$ |  $$ |      $$$$$$$  \$$$$$$$ $$$$$$$  \$$$$$$$\       $$ |  $$ $$ $$$$$$$  $$ |  $$ \$$$$$$$ |
\__|     \__|\______/ \______/\__|  \__|      \_______/ \_______\_______/ \_______|      \__|  \__\__$$  ____/\__|  \__|\_______|
                                                                                                     $$ |                        
                                                                                                     $$ |                        
                                                                                                     \__|                        
$$$$$$$$\$$$$$$$$\ $$$$$$\                                                                                                       
\__$$  __\__$$  __$$  __$$\                                                                                                      
   $$ |     $$ |  $$ /  \__|                                                                                                     
   $$ |     $$ |  \$$$$$$\                                                                                                       
   $$ |     $$ |   \____$$\                                                                                                      
   $$ |     $$ |  $$\   $$ |                                                                                                     
   $$ |     $$ |  \$$$$$$  |                                                                                                     
   \__|     \__|   \______/                                                                                                      
   Made by Marshall_vak
]])

util.AddNetworkString("tts")

//CreateConVar( string name, string value, number flags = FCVAR_NONE, string helptext, number min = nil, number max = nil )

local enable = CreateConVar( "tts_enable", 1, FCVAR_ARCHIVE, "Enables the tts.", 0, 1 )
local adminOnly = CreateConVar( "tts_admin_only", 0, FCVAR_ARCHIVE, "Is the tts admin only?", 0, 1 )
local prefix = CreateConVar( "tts_prefix", "", FCVAR_ARCHIVE, "TTS prefix leave blank or '' to disable. I recommend '>'")
local debug = CreateConVar( "tts_debug", 0, FCVAR_ARCHIVE, "TTS debug")

// I hope you like this Color( 255, 0, 255 )
local function help()
	MsgC(Color( 255, 0, 255 ),[[
Moon Base Alpha TTS Help:
---------------------------------- [ Server Convars ] --------------------------------
[ tts_enable 	 | default: 1  | Enable the tts?    		 		     ]
[ tts_admin_only | default: 0  | Is tts admin only? 			 	     ]
[ tts_prefix     | default: "" | Does the tts have a prefix 			     ]
[ tts_debug   	 | default: 0  | Debug?						     ]
---------------------------------- [ Client Convars ] --------------------------------
[ tts_cl_enabled | default: 1  | Enable the tts client side?    		     ]
[ tts_cl_global  | default: 0  | Play tts globaly?	          		     ]
[ tts_cl_debug   | default: 0  | Debug?					             ]
--------------------------------------------------------------------------------------
]])
end

concommand.Add("tts", help)
concommand.Add("tts_help", help)

//Lots of debug :)

hook.Add("PlayerSay", "mba_tts", function(ply, text)

	if debug:GetBool() then
		if not enable:GetBool() then
			MsgC(Color( 255, 0, 255 ),"TTS is not enabled")
		end
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

	net.Start("tts")
		net.WriteEntity(ply)
		net.WriteString(text)
	net.Broadcast()

end)