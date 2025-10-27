-- from what I understand, makes the local variable Player the "address" to the Player class functions, etc.
local ply = FindMetaTable("Player")

local teamColors = {}

-- Team 0 -> Catcher
-- Team 1 --> Runners

teamColors[0] = Vector(1, 0, 0) -- Catcher color: Red
teamColors[1] = Vector(0, 0, 1) -- Runners color: Blue


-- Function to set player as Catcher
function ply:SetCatcher( freeze )
	self:SetTeam( 0 )
	self:SetPlayerColor( teamColors[0] )
	self:SetHealth( 1000 )
	self:StripWeapons()
	self:Give("weapon_crowbar")
	-- Alert that the server of the new catcher
	for i, ply in ipairs( player.GetAll() ) do
		ply:PrintMessage( HUD_PRINTCENTER, self:GetName() ..  " IS THE NEW CATCHER!" )
	end

	if freeze == "freeze" then
		-- Freeze new catcher for 3 seconds 
		self:Freeze( true )
		timer.Simple( 4, function() self:Freeze( false ) end )
	end
	if boost == "boost" then
		-- boost the new catcher for 7 - 4 = 3 seconds 
		self:SetRunSpeed( 650 )
		timer.Simple( 7, function() self:SetRunSpeed( 350 ) end )
	end
end


function ply:CatcherRespawn( ply )
	self:SetTeam( 0 )
	self:SetPlayerColor( teamColors[0] )
	self:SetHealth( 1000 )
	self:StripWeapons()
	self:Give("weapon_crowbar")
	-- Alert that the server of the new catcher
	for i, ply in ipairs( player.GetAll() ) do
		ply:PrintMessage( HUD_PRINTCENTER, "THE CATCHER HAS RESPAWNED!" )
	end

end


-- Function to set player as Runner
function ply:SetRunner()
	self:SetTeam( 1 )
	self:SetPlayerColor( teamColors[1] )
	self:SetHealth( 1000 )
	self:StripWeapons()
	self:StripAmmo()

	-- Alert that the player is runner
	print( self:GetName() .. " has been assigned as runner!")
end

-- function called when a player is hurt (catched)
function ply:ProcessPlayerHurt(ply, attacker)

  	-- var to verify that the player wasn't hurt by the environment
  	local foundCatcher = false;

	--loop through player list
	for number, playerObject in pairs(player:GetAll()) do

    	-- Find attacker, make him runner
    	if playerObject:GetName() == attacker:GetName() then
    		playerObject:SetRunner()
    		foundCatcher = true;
    		print(playerObject:GetName() .. " has catched someone and been set as runner!")
    	end
    end

    -- If an attacker has been found
    if foundCatcher == true then
		--loop through player list
		for number, playerObject in pairs(player:GetAll()) do
			-- Find catched runner, make him catcher
			if playerObject:GetName() == ply:GetName() then
				playerObject:SetCatcher( "freeze", "boost")
				print(playerObject:GetName() .. " has been catched and set as catcher!")
			end
		end
	else
		-- If an attacker wasn't found, it means the player was hurt by the environment,
		-- so his hp is set back to 100 here
		ply:SetHealth( 1000 )
	end
end

-- This function is run when a player disconnects from the server to determine if he was the catcher,
-- and if indeed he was, a new catcher will be assigned
function ply:DidCatcherDisconnect( ply )
	-- if the disconnected player is in the catcher team
	if #player:GetAll() > 0 then 
		-- choose a random player from the server to be assigned as catcher
		local Rand = math.random(1, #player:GetAll())
		print(HUD_PRINTCENTER, "Disconnected player is in catcher team, assigning random player as catcher.")
		print( player.GetByID(Rand):SetCatcher( "freeze", "boost") )

	else print("Last player on server disconnected.")
	end
end
