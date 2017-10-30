extends Position2D



func set_hero_max_life( what ):
	while get_child_count() > 0:
		get_child(0).queue_free()
	for i in range( what ):
		print(i)
		var pip = preload("res://scenes/World/LifePip.tscn").instance()
		add_child( pip )
		pip.set_frame( 0 )
		var x = i * 16
		pip.set_pos( Vector2( x, 0 ) )

func set_hero_life( what ):
	for node in get_children():
		var p = node.get_position_in_parent()
		if p <= what-1:
			node.set_frame(1)
		else:
			node.set_frame(0)




