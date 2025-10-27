include("shared.lua")
include("cl_hud.lua")

--hiding HUD
function HUDHide( myhud )
	for k, v in pairs{"CHudHealth", "CHudBattery"} do
		if myhud == v then 
			return false 
		end
	end
end
hook.Add("HUDShouldDraw", "HUDHide", HUDHide)

local function DisallowSpawnMenu( )
	if LocalPlayer():IsUserGroup("user") then
		return false
	else
		return true
	end
end
	
hook.Add( "SpawnMenuOpen", "DisallowSpawnMenu", DisallowSpawnMenu)


-- In cl_init.lua or a clientside file
hook.Add("OnContextMenuOpen", "RestrictContextMenu", function()
    if not LocalPlayer():IsAdmin() then
        return false
    end
end)


--[[
-- HUD generator function
function GM:HUDPaint()
	print("Hud has started painting")
	self.BaseClass:HUDPaint()
	local ply = LocalPlayer()
	local HP = LocalPlayer():Health()
	local ARM = LocalPlayer():Armor()

	surface.CreateFont("MyFont", {font = "ScoreboardText", size = 40, weight = 250, antialias = false, shadow = false})
	surface.SetTextColor(20, 180, 50, 255)
	surface.SetTextPos(20, 20)
	surface.SetFont( "MyFont" )
	surface.DrawText( HP )
	print("Hud has finished painting")
end

 ]]--


