extends Camera2D

func set_limits( from_rect ):
	set( "limit/left", from_rect.pos.x )
	set( "limit/top", from_rect.pos.y )
	set( "limit/right", from_rect.end.x )
	set( "limit/bottom", from_rect.end.y )