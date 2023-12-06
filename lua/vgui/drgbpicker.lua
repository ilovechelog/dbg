--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/drgbpicker.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

AccessorFunc( PANEL, "m_RGB", "RGB" )

function PANEL:Init()

	self:SetRGB( color_white )

	self.Material = Material( "gui/colors.png" ) -- TODO: Light/Dark

	self.LastX = -100
	self.LastY = -100

end

function PANEL:GetPosColor( x, y )

	local con_x = ( x / self:GetWide() ) * self.Material:Width()
	local con_y = ( y / self:GetTall() ) * self.Material:Height()

	con_x = math.Clamp( con_x, 0, self.Material:Width() - 1 )
	con_y = math.Clamp( con_y, 0, self.Material:Height() - 1 )

	local col = self.Material:GetColor( con_x, con_y )

	return col, con_x, con_y

end

function PANEL:OnCursorMoved( x, y )

	if ( !input.IsMouseDown( MOUSE_LEFT ) ) then return end

	local col = self:GetPosColor( x, y )

	if ( col ) then
		self.m_RGB = col
		self.m_RGB.a = 255
		self:OnChange( self.m_RGB )
	end

	self.LastX = x
	self.LastY = y

end

function PANEL:OnChange( col )

	-- Override me

end

function PANEL:OnMousePressed( mcode )

	self:MouseCapture( true )
	self:OnCursorMoved( self:CursorPos() )

end

function PANEL:OnMouseReleased( mcode )

	self:MouseCapture( false )
	self:OnCursorMoved( self:CursorPos() )

end

function PANEL:Paint( w, h )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( self.Material )
	surface.DrawTexturedRect( 0, 0, w, h )

	surface.SetDrawColor( 0, 0, 0, 250 )
	self:DrawOutlinedRect()

	surface.DrawRect( 0, self.LastY - 2, w, 3 )

	surface.SetDrawColor( 255, 255, 255, 250 )
	surface.DrawRect( 0, self.LastY - 1, w, 1 )

end

derma.DefineControl( "DRGBPicker", "", PANEL, "DPanel" )
