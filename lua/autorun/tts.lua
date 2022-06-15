if SERVER then
    MsgC(Color(255, 255, 255), "[", Color(255, 0, 255), "TTS", Color(255, 255, 255), "] Hello World!\n")
    AddCSLuaFile("tts/cl_tts.lua")
    AddCSLuaFile("tts/sh_tts.lua")

    include("tts/sv_tts.lua")
else
    include("tts/cl_tts.lua")
end