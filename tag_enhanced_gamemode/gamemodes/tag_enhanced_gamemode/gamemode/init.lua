AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("player.lua")

function GM:PlayerInitialSpawn( ply )
	print("Player " .. ply:Name() .. " spawned.")


	-- If the server is empty, assign the player as catcher!
	if #player:GetAll() <= 1 then
		ply:SetCatcher()
	end

	-- If there is already a catcher in the server, assign player as runner!
	if #player:GetAll() > 1 then
		ply:SetRunner()
	end

end

function GM:PlayerInitialSpawn ()
	ply:kill()
	timer.Simple(1, function ply:Spawn() end)
end

function GM:PlayerSpawn( ply, attacker )

	if ply:Team() == 0 then
		ply:CatcherRespawn(ply, attacker)
	end

	print("Players in the server:")

	for k, v in pairs( player:GetAll() ) do
		print( "- " .. v:GetName() )
	end

end

function GM:PlayerHurt( ply, attacker ) 
    print( ply:GetName() .. " is being attacked by: " .. attacker:GetName() )

    ply:ProcessPlayerHurt(ply, attacker)
end 

function GM:PlayerDisconnected( ply )
	if ply:Team() == 0 then
	timer.Simple( 5, function() ply:DidCatcherDisconnect( ply ) end )
	end
end

function GM:PlayerDeath( ply, attacker )
	timer.Simple( 0, function() ply:Spawn() end )
end

hook.Add( "PlayerSay", "Kill", function( ply, text )
	if ( string.lower( text ) == "!kill") then
		ply:Kill()
	end
end )

--[[---------------------------------------------------------
	If false is returned then the context menu is never created.
	This saves load times if your mod doesn't actually use the
	context menu for any reason.
-----------------------------------------------------------]]
function GM:ContextMenuEnabled()
	return true
end

--[[---------------------------------------------------------
	Called when context menu is trying to be opened.
	Return false to dissallow it.
-----------------------------------------------------------]]
function GM:ContextMenuOpen()
	return true
end

function GM:ContextMenuOpened()
	self:SuppressHint( "OpeningContext" )
	self:AddHint( "ContextClick", 20 )
end

hook.Add( "PlayerSwitchFlashlight", "BlockFlashLight", function( ply, enabled )
	return true
end )

local speed_slowwalk = 40
local speed_walk = 200
local speed_run = 350
local speed_crouchwalk = 0.3

local RMSEnabled = CreateConVar( "sv_rms_enable", 1, FCVAR_NONE, "Toggles Realistic Movement Speed mod", 0, 1 )

cvars.AddChangeCallback( "sv_rms_enable", function()
    print("Respawn for changes to take effect.")
end)

hook.Add("PlayerSpawn", "RMSHook", function(player)
    if RMSEnabled:GetInt() == 1 then 
        timer.Simple(0.1, function()
            player:SetWalkSpeed(speed_walk)
            player:SetRunSpeed(speed_run)
            player:SetSlowWalkSpeed(speed_slowwalk)
            player:SetCrouchedWalkSpeed(speed_crouchwalk)
        end)
    end
end)

hook.Add("PlayerNoClip", "FeelFreeToTurnItOff", function(ply, desiredState)
    if desiredState == true then
		if (ply:IsSuperAdmin() )then
			return true     
		else
			return false
		end
    end
end)
