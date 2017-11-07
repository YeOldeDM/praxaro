extends Position2D
tool

export( int, "Retain", "Right", "Left" ) var facing = 0 setget _set_facing

func _ready():
	get_node("Sprite").queue_free()

func _set_facing( what ):
	facing = what
	if is_inside_tree():
		var x = [ 1, 1, -1 ][ facing ]
		get_node( "Sprite" ).set_scale( Vector2( x, 1 ) )


