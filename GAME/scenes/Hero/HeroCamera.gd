extends Camera2D

var shake_amp = 0

var limits = Rect2()

func set_limits( from_rect ):
	self.limits = from_rect
	enable_limits()


func enable_limits():
	set( "limit/left", self.limits.pos.x )
	set( "limit/top", self.limits.pos.y )
	set( "limit/right", self.limits.end.x )
	set( "limit/bottom", self.limits.end.y )

func disable_limits( buffer = 10 ):
	set( "limit/left", self.limits.pos.x - buffer )
	set( "limit/top", self.limits.pos.y - buffer )
	set( "limit/right", self.limits.end.x + buffer )
	set( "limit/bottom", self.limits.end.y + buffer )

func shake( amp ):
	self.shake_amp = amp
	set_process(true)


func _process(delta):
	var s = shake_amp * delta
	var x = rand_range( -s, s )
	var y = rand_range( -s, s )
	set_zoom( Vector2( 1+x, 1+y ) )
#	set_offset( Vector2( x, y ) )
	shake_amp *= 0.68
#	disable_limits( s )
	if shake_amp <= 0.01:
		shake_amp = 0
#		call_deferred( "enable_limits" )
		set_offset( Vector2() )
		set_zoom( Vector2( 1, 1 ) )
		set_process(false)
