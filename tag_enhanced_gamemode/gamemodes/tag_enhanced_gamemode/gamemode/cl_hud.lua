-- Initializing the HUD table
tagHud = { };

-- This function just takes a color object and splits it up into multiple returns. This is specifically for the "surface" functions, since none of them accept a color object.
local function clr( color ) return color.r, color.g, color.b, color.a; end

-- function that draws a bar
function tagHud:PaintBar( x, y, w, h, colors, value )

	self:PaintPanel( x, y, w, h, colors );			-- paint border and background
 
	x = x + 1; y = y + 1;					-- fix positions and sizes
	w = w - 2; h = h - 2;
 
	local width = w * math.Clamp( value, 0, 1 );		-- calc bar width
	local shade = 4;					-- set shade constant
 
	surface.SetDrawColor( clr( colors.shade ) );		-- set shade color
	surface.DrawRect( x, y, width, shade );			-- draw shade
 
	surface.SetDrawColor( clr( colors.fill ) );		-- set fill color
	surface.DrawRect( x, y + shade, width, h - shade );	-- draw fill

end


--[[ The box ]]--
-- Now for the background of the bar

function tagHud:PaintPanel( x, y, w, h, colors )
 
	surface.SetDrawColor( clr( colors.border ) );		-- set border color
	surface.DrawOutlinedRect( x, y, w, h );			-- draw border
 
	x = x + 1;						-- fix positions and sizes
	y = y + 1;
	w = w - 2;
	h = h - 2;
 
	surface.SetDrawColor( clr( colors.background ) );	-- set background color
	surface.DrawRect( x, y, w, h );				-- and paint background
 
end


--[[ The message ]]--

-- Now it's time for text
function tagHud:PaintText( x, y, text, font, colors )
 
	surface.SetFont( font );			-- set text font
 
	surface.SetTextPos( x + 1, y + 1 );		-- set shadow position
	surface.SetTextColor( clr( colors.shadow ) );	-- set shadow color
	surface.DrawText( text );			-- draw shadow text
 
	surface.SetTextPos( x, y );			-- set text position
	surface.SetTextColor( clr( colors.text ) );	-- set text color
	surface.DrawText( text );			-- draw text
 
end

-- function that sets the text size
function tagHud:TextSize( text, font )
 
	surface.SetFont( font );
	return surface.GetTextSize( text );
 
end


--[[ Setting up the actual HUD ]]--

-- creating the font
surface.CreateFont("CurrentTeam", {font = "Trebuchet24",
                                    size = 28,
                                    weight = 1000})

-- the vars table is where the sizes and offsets are kept

local vars =
{
 
	font = "CurrentTeam",
 
	padding = 10,
	margin = 35,
 
	text_spacing = 2,
	bar_spacing = 5,
 
	bar_height = 5,
 
 	width = 0.20,
	widthCatcher = 0.20,
	widthRunner = 0.245,
	widthError = 0.38
 
};

--the colors table is where we'll keep the colors

local colors =
{
 
	background =
	{
 
		border = Color( 0, 0, 0, 255 ),
		background = Color( 0, 0, 0, 250 )
 
	},
 
	text =
	{
 
		shadow = Color( 0, 0, 0, 200 ),
		text = Color( 255, 255, 255, 255 )
 
	},
 
	health_bar =
	{
 
		border = Color( 255, 0, 0, 255 ),
		background = Color( 255, 0, 0, 75 ),
		shade = Color( 255, 104, 104, 255 ),
		fill = Color( 232, 0, 0, 255 )
 
	},
 
	suit_bar =
	{
 
		border = Color( 0, 0, 255, 255 ),
		background = Color( 0, 0, 255, 75 ),
		shade = Color( 136, 136, 255, 255 ),
		fill = Color( 0, 0, 219, 255 )
 
	}
 
};

-- The HUD Draw event setup

local function HUDPaint( )
 
	client = client or LocalPlayer( );				-- set a shortcut to the client
	if( !client:Alive( ) ) then return; end				-- don't draw if the client is dead
 
	local _, th = tagHud:TextSize( "TEXT", vars.font );		-- get text size( height in this case )
 
	local i = 1;							-- shortcut to how many items( bars + text ) we have
 
	local width = vars.width * ScrW( );				-- calculate width
	local bar_width = 0.20 - ( vars.padding * i );			-- calculate bar width and element height
	local height = ( vars.padding * i ) + ( th * i ) + ( vars.text_spacing * i ) + ( vars.bar_height * i ) + vars.bar_spacing;
 
	local x = vars.margin;						-- get x position of element
	local y = ScrH( ) - vars.margin - height;			-- get y position of element
 
	local cx = x + vars.padding;					-- get x and y of contents
	local cy = y + vars.padding;
 
	local by = th + vars.text_spacing;				-- calc text position

	local text = client:Team()

	local teamWidth = 0.20 * ScrW( );	

	-- drawing the team info to the box
	if client:Team() == 0 then
		text = "CATCHER"
		teamWidth = vars.widthCatcher * ScrW( );	
	elseif client:Team() == 1 then
		text = "RUNNER"
		teamWidth = vars.widthRunner * ScrW( );	
	else
		text = "There was a problem, please reconnect!"
		teamWidth = vars.widthError * ScrW( );	
	end

	tagHud:PaintPanel( x, y, teamWidth, height, colors.background );	-- paint the background panel
	tagHud:PaintText( cx, cy, text, vars.font, colors.text );			-- paint the text
end
hook.Add( "HUDPaint", "PaintOurHud", HUDPaint );
