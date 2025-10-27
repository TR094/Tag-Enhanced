GM.Name = "tag"
GM.Author = "MP"
GM.Email = "N/A"
GM.Website = "N/A"

DeriveGamemode("sandbox")

-- setting up the teams
team.SetUp(0, "Catcher", Color(255, 0, 0))
team.SetUp(1, "Runners", Color(0, 0, 255))

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

