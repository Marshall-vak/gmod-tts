include("tts/shared.lua")

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

net.Receive("tts", function(serverTable)
    if not GetConVar("tts_allow_disable"):GetBool() then if not tts.enabled:GetBool() then return end end

    local table = hook.Call( "postTTS", serverTable )

    if not table.tts then return end

    if tts.debug:GetBool() and table.entity:IsPlayer() then MsgC(Color( 255, 0, 255 ),"net recieved! table.entity: " .. table.entity:Nick() .. " txt: " .. txt .. " global: " .. global) end

    if tts.global:GetBool() or table.global or GetConVar("tts_globalForce"):GetBool() then
        
        if tts.debug:GetBool() then MsgC(Color(255, 0, 255), "Playing sound globally.") end

        sound.PlayURL("https://tts.cyzon.us/tts/?text=" .. table.text,"",function(station)
            if ( IsValid( station ) ) then
                station:Play()
                //station:SetVolume(tts.volume:GetFloat())
                print(station:GetVolume())
            else
                if tts.debug:GetBool() then  MsgC(Color(255, 0, 0), "TTS: Attempted to play borked sound.") end
            end
        end)

    else

        //https://wiki.facepunch.com/gmod/sound.PlayURL
        sound.PlayURL( "https://tts.cyzon.us/tts/?text=" .. table.text, "3d", function( station )
            if ( IsValid( station ) ) then

                local value = math.random(math.huge)
                hook.Add("Think", "setTTSpos" .. value, function()
                    if station:GetState() == 1 then
                        station:SetPos( table.entity:GetPos() )

                        if tts.debug:GetBool() then MsgC(Color(255, 0, 255), "state" .. station:GetState()) end
                    else
                        hook.Remove("Think", "setTTSpos" .. value)

                        if tts.debug:GetBool() then MsgC(Color(255, 0, 255), "removed hook") end
                    end
                end)

                station:Play()
            
            else
                if tts.debug:GetBool() then MsgC(Color(255, 0, 0), "TTS: Attempted to play borked sound.") end
            end
        end)

    end
end)