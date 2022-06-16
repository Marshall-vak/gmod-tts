include("sh_tts.lua")

if not tts.enable:GetBool() then return end

//for copy pasta
/*
if tts.debug:GetBool() then 
    MsgC(Color( 255, 0, 255 ),"")
end
*/

tts.version = 2.0

tts.logo =[[                     
$$$$$$$$\$$$$$$$$\ $$$$$$\
\__$$  __\__$$  __$$  __$$\
   $$ |     $$ |  $$ /  \__|
   $$ |     $$ |  \$$$$$$\
   $$ |     $$ |   \____$$\
   $$ |     $$ |  $$\   $$ |
   $$ |     $$ |  \$$$$$$  |
   \__|     \__|   \______/
Loaded TTS Version 2.0 Made by Marshall_vak
]]

if tts.debug:GetBool() then 
    MsgC(Color( 255, 0, 255 ),"TTS: current gamemode is: " .. string.lower(engine.ActiveGamemode()) .. "\n")
end

//print big tts
funPrint(tts.logo)

//create tts net
util.AddNetworkString("tts")


tts.support = string.lower(engine.ActiveGamemode())
if not file.Exists( "lua/tts/gamemodes/" .. tts.support .. ".lua" , "GAME" ) then tts.support = "sandbox" end
    
MsgC(Color( 255, 0, 255 ),"Starting TTS with " .. tts.support .. " support!\n")
AddCSLuaFile("tts/gamemodes/" .. tts.support .. ".lua")
include("gamemodes/" .. tts.support .. ".lua")
SetGlobalString( "tts_support", tts.support )

// Create help command. I hope you like this Color( 255, 0, 255 )
local function help()
	funPrint([[
Moon Base Alpha Made TTS by Marshall_vak TTS Help:
---------------------------------- [ Server Convars ] --------------------------------
[ tts_enable 	     | default: 1  | Enable the tts?    		             ]
[ tts_admin_only     | default: 0  | Is tts admin only? 			     ]
[ tts_prefix         | default: "" | Does the tts have a prefix 	             ]
[ tts_say_name       | default: 0  | Say the player name in tts?		     ]
[ tts_specdm         | default: 1  | Enable ttt specdm support?                      ]
[ tts_allow_disable  | default: 1  | Should the client be allowed to disable the tts ]
[ tts_debug   	     | default: 0  | Debug?					     ]
[ tts_globalForce    | default: 0  | Should the tts be global for all players?       ]
---------------------------------- [ Client Convars ] --------------------------------
[ tts_cl_enabled     | default: 1  | Enable the tts client side?    		     ]
[ tts_cl_volume  | default: 1  | Volume of the tts                                   ]
[ tts_cl_global      | default: 0  | Play tts globaly?	          		     ]
[ tts_cl_debug       | default: 0  | Debug?					     ]
--------------------------------------------------------------------------------------
]])
end

concommand.Add("tts", help)
concommand.Add("tts_help", help)

tts.blackList = {
    "http://",
    "https://",
    "<emote=",
    "<color="
}

hook.Add("PlayerSay", "mba_tts", function(ply, text, team)
    //Max length of api 1024
	if string.len(text) > 1024 then
		timer.Simple(0.1, function()
            if not IsValid(ply) then return end

			ply:SendLua([[chat.AddText(Color(255, 255, 255), "[", Color(255, 0, 255), "TTS", Color(255, 255, 255), "] TTS: Mesasge is too long!")]])
		end)
		return
	end

    if tts.adminOnly:GetBool() and not ply:IsAdmin() then return end

    if tts.prefix:GetString() and not string.StartWith(text, tts.prefix:GetString()) then return end

    if tts.prefix:GetString() then text = string.sub( text, #tts.prefix:GetString() + 1) end

	if tts.sayName:GetBool() then text = ply:Nick() .. "Said. " .. text end

    for i = 1, #tts.blackList do
        if string.find(string.lower(text), tts.blackList[i]) then
            return
        end
    end

    if GetConVar("tts_debug"):GetBool() then MsgC(Color( 255, 0, 255 ),"Calling hook with text: " .. text .. "\n") end

    local table = hook.Run( "preTTS", ply, text, team )

    if not table.tts then return end

    if GetConVar("tts_debug"):GetBool() then MsgC(Color( 255, 0, 255 ),"Sending net message\n") end

    net.Start("tts")
        net.WriteTable(table)
	net.Broadcast()
end)