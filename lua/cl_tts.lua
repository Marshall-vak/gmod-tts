//CreateClientConVar( string name, string default, boolean shouldsave = true, boolean userinfo = false, string helptext, number min = nil, number max = nil )

local enabled = CreateClientConVar( "tts_cl_enabled", 1, true, false, "Enable tts? (can be overwritten by the server)", 0, 1)
local global = CreateClientConVar( "tts_cl_global", 0, true, false, "Does the tts play globally? (can be overwritten by the server)", 0, 1)
//egg
local debug = CreateClientConVar( "tts_cl_debug", 0, true, false, "Enable pink console?", 0, 1)

// Create client help command. I hope you like this Color( 255, 0, 255 )
local function help()
	MsgC(Color( 255, 0, 255 ),[[
Moon Base Alpha TTS Help:
---------------------------------- [ Client Convars ] --------------------------------
[ tts_cl_enabled | default: 1  | Enable the tts? (can be overwritten by the server)  ]
[ tts_cl_global  | default: 0  | Play tts globaly? (can be overwritten by the server)]
[ tts_cl_debug   | default: 0  | Debug?					             ]
--------------------------------------------------------------------------------------
]])
end

concommand.Add("tts", help)
concommand.Add("tts_help", help)

hook.Add( "InitPostEntity", "tts_startup", function()
    if not GetConVar("tts_allow_disable"):GetBool() then
        if debug:GetBool() then 
            MsgC(Color( 255, 0, 255 ),"tts_allow_disable is enabled server side removing cl_enable")
        end

        concommand.Remove("tts_cl_enabled")
    end

    hook.Remove( "InitPostEntity", "tts_startup")
end)

net.Receive("tts", function()
    if not GetConVar("tts_allow_disable"):GetBool() then
        if not enabled:GetBool() then return end
    end

    local ply = net.ReadEntity()
    local text = net.ReadString()
    local global = net.ReadInt()

    if debug:GetBool() then 
        MsgC(Color( 255, 0, 255 ),"net recieved! ply: " .. ply:Nick() .. " txt: " .. txt .. " global: " .. global)
    end

    if global:GetBool() or global then
        
        if debug then 
            MsgC(Color(255, 0, 255), "Playing sound globally.")
        end

        sound.PlayURL("https://tts.cyzon.us/tts/?text=" .. text,"",function(station)
            if ( IsValid( station ) ) then
                station:Play()
            end
        end)

    else

        //https://wiki.facepunch.com/gmod/sound.PlayURL
        sound.PlayURL( "https://tts.cyzon.us/tts/?text=" .. text, "3d", function( station )
            if ( IsValid( station ) ) then

                local value = math.random(math.huge)
                hook.Add("Think", "setTTSpos" .. value, function()
                    if station:GetState() == 1 then
                        station:SetPos( ply:GetPos() )

                        if debug:GetBool() then
                            MsgC(Color(255, 0, 255), "state" .. station:GetState())
                        end
                    else
                        hook.Remove("Think", "setTTSpos" .. value)

                        if debug:GetBool() then
                            MsgC(Color(255, 0, 255), "removed hook")
                        end
                    end
                end)

                station:Play()
            
            else
            
                MsgC(Color(255, 0, 255), "TTS: Attempted to play borked sound.")
            
            end
        end)

    end
end)

MsgC(Color(255, 0, 255), "TTS Loaded! Made by Marshall_vak")