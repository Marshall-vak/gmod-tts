//debug
local debug = CreateConVar( "tts_debug", 0, FCVAR_ARCHIVE, "TTS debug")

//for copy pasta
/*
if debug:GetBool() then 
    MsgC(Color( 255, 0, 255 ),"")
end
*/

//send client file to clients on join
AddCSLuaFile("cl_tts.lua")

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
]])
MsgC(Color( 255, 0, 255 ),[[

                                                                                                     $$ |                        
                                                                                                     $$ |                        
                                                                                                     \__|                        
$$$$$$$$\$$$$$$$$\ $$$$$$\                                                                                                       
\__$$  __\__$$  __$$  __$$\                                                                                                      
   $$ |     $$ |  $$ /  \__|                                                                                                     
   $$ |     $$ |  \$$$$$$\                                                                                                       
]])
MsgC(Color( 255, 0, 255 ),[[
   $$ |     $$ |   \____$$\                                                                                                      
   $$ |     $$ |  $$\   $$ |                                                                                                     
   $$ |     $$ |  \$$$$$$  |                                                                                                     
   \__|     \__|   \______/                                                                                                      
   Made by Marshall_vak

]])

//make life easier
function setContains(set, key)
    if debug:GetBool() then 
        MsgC(Color( 255, 0, 255 ),"setContains function called set: " .. set .. " key: " .. key)
    end

    return set[key] ~= nil
ends

//only 4 supported gamemodes at this time
local support
local supportedGamemodes = {
    "sandbox",
    "prophunt",
    "ttt",
    "murder"
}

//if the game mode is not supported then set as sandbox
if supportedGamemodes[gamemode.Get()] then 
    if debug:GetBool() then 
        MsgC(Color( 255, 0, 255 ),"support set to " .. gamemode.Get())
    end

    support = gamemode.Get()
else
    if debug:GetBool() then 
        MsgC(Color( 255, 0, 255 ),"gamemode not supported continuing with sandbox")
    end

    support = "sandbox"
end

MsgC(Color( 255, 0, 255 ),"Starting TTS with " .. support .. " support!")
include("sv_tts_" .. support .. ".lua")

//create tts net
util.AddNetworkString("tts")

//https://wiki.facepunch.com/gmod/Global.CreateConVar
//CreateConVar( string name, string value, number flags = FCVAR_NONE, string helptext, number min = nil, number max = nil )

//create  global convars
local enable = CreateConVar( "tts_enable", 1, FCVAR_ARCHIVE, "Enables the tts.", 0, 1 )
local adminOnly = CreateConVar( "tts_admin_only", 0, FCVAR_ARCHIVE, "Is the tts admin only?", 0, 1 )
local prefix = CreateConVar( "tts_prefix", "", FCVAR_ARCHIVE, "TTS prefix leave blank or '' to disable. I recommend '>'")
local sayName = CreateConVar( "tts_say_name", 0, FCVAR_ARCHIVE, "Include the player name in the tts?")
local specDm = CreateConVar( "tts_specdm", 1, FCVAR_ARCHIVE, "Enable specDm support? (If you dont know what specDm is then just ignore it)")
local allowDisable = CreateConVar( "tts_allow_disable", 1, FCVAR_ARCHIVE, "Should clients be able to disable the tts?")

// Create help command. I hope you like this Color( 255, 0, 255 )
local function help()
	MsgC(Color( 255, 0, 255 ),[[
Moon Base Alpha TTS Help:
---------------------------------- [ Server Convars ] --------------------------------
[ tts_enable 	     | default: 1  | Enable the tts?    		 		     ]
[ tts_admin_only     | default: 0  | Is tts admin only? 			 	     ]
[ tts_prefix         | default: "" | Does the tts have a prefix 			     ]
[ tts_say_name       | default: 0  | Say the player name in tts?			     ]
[ tts_specdm         | default: 1  | Enable ttt specdm support?             ]
[ tts_allow_disable  | default: 1  | Should the client be allowed to disable the tts ]
[ tts_debug   	     | default: 0  | Debug?						     ]
---------------------------------- [ Client Convars ] --------------------------------
[ tts_cl_enabled     | default: 1  | Enable the tts client side?    		     ]
[ tts_cl_global      | default: 0  | Play tts globaly?	          		     ]
[ tts_cl_debug       | default: 0  | Debug?					             ]
--------------------------------------------------------------------------------------
]])
end

concommand.Add("tts", help)
concommand.Add("tts_help", help)