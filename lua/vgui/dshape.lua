--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/dshape.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

AccessorFunc( PANEL, "m_Color", "Color" )
AccessorFunc( PANEL, "m_BorderColor", "BorderColor" )
AccessorFunc( PANEL, "m_Type", "Type" )

local RenderTypes = {}

function RenderTypes.Rect( pnl )
	surface.SetDrawColor( pnl:GetColor() )
	surface.DrawRect( 0, 0, pnl:GetSize() )
end

function PANEL:Init()

	self:SetColor( color_white )

	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )

end

function PANEL:Paint()

	RenderTypes[ self.m_Type ]( self )

end

derma.DefineControl( "DShape", "A shape", PANEL, "DPanel" )

-- Convenience function
function VGUIRect( x, y, w, h )
	local shape = vgui.Create( "DShape" )
	shape:SetType( "Rect" )
	shape:SetPos( x, y )
	shape:SetSize( w, h )
	return shape
end
