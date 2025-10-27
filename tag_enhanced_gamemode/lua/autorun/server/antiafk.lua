--THIS CODE IS A MODIFICATION OF THE SIMPLE ANTIAFK PLUGIN THATS MADE BY https://steamcommunity.com/id/jordiebg ALL CREDITS GOES TO HIM!

AddCSLuaFile("antiafk.lua")

if engine.ActiveGamemode() == "tag_enhanced_gamemode" then
    local AFK_TIME = 150
    hook.Add("PlayerInitialSpawn", "MakeAFKVar", function(ply)
        ply.NextAFK = CurTime() + AFK_TIME 
    end)

    hook.Add("Think", "HandleAFKPlayers", function()
        for _, ply in pairs(player.GetAll()) do
            if ply:IsConnected() and ply:IsFullyAuthenticated() and ply:Team() == 0 then
                if not ply.NextAFK then ply.NextAFK = CurTime() + AFK_TIME end
                local afktime = ply.NextAFK
                if (CurTime() >= afktime) then
                    ply.NextAFK = nil
                    ply:SetRunner(ply)
                    ply:DidCatcherDisconnect(ply)
                end
            end
        end
    end)

    hook.Add("KeyPress", "PlayerMoved", function(ply, key)
        ply.NextAFK = CurTime() + AFK_TIME
		AFK = false
    end)
end