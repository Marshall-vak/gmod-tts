tts = tts or {}

tts.debug = CreateConVar( "tts_debug", 0, FCVAR_ARCHIVE, "TTS debug")
tts.enable = CreateConVar( "tts_enable", 1, FCVAR_ARCHIVE, "Enables the tts.", 0, 1 )

tts.adminOnly = CreateConVar( "tts_admin_only", 0, FCVAR_ARCHIVE, "Is the tts admin only?", 0, 1 )
tts.prefix = CreateConVar( "tts_prefix", "", FCVAR_ARCHIVE, "TTS prefix leave blank or '' to disable. I recommend '>'")
tts.sayName = CreateConVar( "tts_say_name", 0, FCVAR_ARCHIVE, "Include the player name in the tts?")
tts.specDm = CreateConVar( "tts_specdm", 0, FCVAR_ARCHIVE, "Enable specDm support? (If you dont know what specDm is then just ignore it)")
tts.birdsEyeView = CreateConVar( "tts_birds_eye_view", 0, FCVAR_ARCHIVE, "Enable birds eye view support? (If you dont know what Birds Eye View is then just ignore it)")
tts.allowDisable = CreateConVar( "tts_allow_disable", 1, FCVAR_ARCHIVE, "Should clients be able to disable the tts?")
tts.globalForce = CreateConVar( "tts_globalForce", 1, FCVAR_ARCHIVE, "Should the tts be global for all players?")

tts.enabled = CreateClientConVar( "tts_cl_enabled", 1, true, false, "Enable tts? (can be overwritten by the server)", 0, 1)
tts.global = CreateClientConVar( "tts_cl_global", 0, true, false, "Does the tts play globally? (can be overwritten by the server)", 0, 1)
tts.debug = CreateClientConVar( "tts_cl_debug", 0, true, false, "Enable pink console?", 0, 1)
tts.volume = CreateClientConVar( "tts_cl_volume", 1, true, false, "Volume of the tts", 0, 1)

function funPrint(table)
    local l, c1, c2 = 0, Color(0, 195, 255):ToVector() , Color(255, 255, 28):ToVector()
    for i = 1, #table do
        if table[i] == "\n" then
            l = 0
            MsgC("\n")
        else
            l = l + 1
            local cvec = LerpVector(l / 61, c1, c2) -- if Color:ToVector exists in menu, then why not Vector:ToColor??
            MsgC(Color(cvec.x * 255, cvec.y * 255, cvec.z * 255), table[i])
        end
    end
    MsgN()
end

//make life easier
function setContains(set, key)
    if tts.debug:GetBool() then 
        MsgC(Color( 255, 0, 255 ),"setContains function called set: " .. set .. " key: " .. key .. "\n")
    end

    return set[key] ~= nil
end

if not SERVER then
    hook.Add( "InitPostEntity", "tts_startup", function()
        if not GetConVar("tts_allow_disable"):GetBool() then
            if tts.debug:GetBool() then MsgC(Color( 255, 0, 255 ),"tts_allow_disable is enabled server side removing cl_enable") end
    
            concommand.Remove("tts_cl_enabled")
        end
    
        funPrint([[Client TTS Loaded! Made by Marshall_vak]])
        hook.Remove( "InitPostEntity", "tts_startup")
    end)
end

tts.supportedGamemodes = {}

local files, directories = file.Find( "tts/gamemodes", "LUA" )
for k, v in pairs( files ) do
    print(string.gsub( v, ".lua", "" ))
    table.Add(tts.supportedGamemodes, string.gsub( v, ".lua", "" ))
end

//if the game mode is not supported then set as sandbox
    if tts.supportedGamemodes[engine.ActiveGamemode()] then 
        if tts.debug:GetBool() then 
            MsgC(Color( 255, 0, 255 ),"Support set to " .. engine.ActiveGamemode() .. "\n")
        end
    
        support = engine.ActiveGamemode()
    else
        if tts.debug:GetBool() then 
            MsgC(Color( 255, 0, 255 ),"Gamemode not supported continuing with sandbox!\n")
        end
    
        support = "sandbox"
    end

MsgC(Color( 255, 0, 255 ),"Starting TTS with " .. support .. " support!\n")
include("tts/gamemodes/" .. support .. ".lua")
if server then AddCSLuaFile("tts/gamemodes/" .. support .. ".lua") end


//egg thanks shadowz ( Shadowz says Hi )