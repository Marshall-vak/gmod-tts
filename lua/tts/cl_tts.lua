local tempdisable = true

include("sh_tts.lua")
timer.Simple(0.1, function()
    include("tts/gamemodes/" .. GetGlobalString( "tts_support", tts.support ) .. ".lua")
    tempdisable = false
end)

local function help() funPrint([[Moon Base Alpha TTS Help:
---------------------------------- [ Client Convars ] --------------------------------
[ tts_cl_enabled | default: 1  | Enable the tts? (can be overwritten by the server)  ]
[ tts_cl_volume  | default: 1  | Volume of the tts                                   ]
[ tts_cl_global  | default: 0  | Play tts globaly? (can be overwritten by the server)]
[ tts_cl_debug   | default: 0  | Debug?					             ]
--------------------------------------------------------------------------------------
TTS Made by Marshall_vak
]]) 
end

concommand.Add("tts", help)
concommand.Add("tts_help", help)

hook.Add( "InitPostEntity", "tts_startup", function()
    if not GetConVar("tts_allow_disable"):GetBool() then
        if tts.cl_debug:GetBool() then MsgC(Color( 255, 0, 255 ),"tts_allow_disable is enabled server side removing cl_enable") end

        concommand.Remove("tts_cl_enabled")
    end

    funPrint([[Client TTS Loaded! Made by Marshall_vak]])
    hook.Remove("InitPostEntity", "tts_startup")
end)

net.Receive("tts", function()
    if not GetConVar("tts_allow_disable"):GetBool() and not tts.enabled:GetBool() then return end
    local serverTable = net.ReadTable()

    if tempdisable then return end

    local falseTable = {}
    falseTable.tts = false
    falseTable.text = "false table"

    local table = hook.Run( "postTTS", serverTable )// or falseTable

    if not table.tts then return else if tts.cl_debug:GetBool() then MsgC(Color( 255, 0, 255 ),"aaaaaa\n") end end

    if table.team and table.ply:IsPlayer() and not (table.ply:Team() == LocalPlayer():Team()) then return end

    if tts.cl_debug:GetBool() and table.ply:IsPlayer() then MsgC(Color( 255, 0, 255 ),"net recieved! table.ply: " .. table.ply:Nick() .. " txt: " .. table.text .. " global: " .. tostring(table.global)) end

    if tts.global:GetBool() or table.global or GetConVar("tts_globalForce"):GetBool() then
        
        if tts.cl_debug:GetBool() then MsgC(Color(255, 0, 255), "Playing sound globally.") end

        sound.PlayURL("https://tts.dinosite.net/tts/?text=" .. table.text,"",function(station)
            if ( IsValid( station ) ) then
                station:Play()
                station:SetVolume(tts.volume:GetFloat())
            else
                if tts.cl_debug:GetBool() then  MsgC(Color(255, 0, 0), "TTS: Attempted to play borked sound.") end
            end
        end)

    else

        //https://wiki.facepunch.com/gmod/sound.PlayURL
        sound.PlayURL( "https://tts.cyzon.us/tts/?text=" .. table.text, "3d", function( station )
            if ( IsValid( station ) ) then

                local value = math.random(math.huge)
                hook.Add("Think", "setTTSpos" .. value, function()
                    if station:GetState() == 1 then
                        station:SetPos( table.ply:GetPos() )

                        if tts.cl_debug:GetBool() then MsgC(Color(255, 0, 255), "state" .. station:GetState()) end
                    else
                        hook.Remove("Think", "setTTSpos" .. value)

                        if tts.cl_debug:GetBool() then MsgC(Color(255, 0, 255), "removed hook") end
                    end
                end)

                station:Play()
                station:SetVolume(tts.volume:GetFloat())
            
            else
                if tts.cl_debug:GetBool() then MsgC(Color(255, 0, 0), "TTS: Attempted to play borked sound.") end
            end
        end)

    end
end)
