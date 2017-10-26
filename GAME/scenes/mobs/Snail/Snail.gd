extends KinematicBody2D

onready var WallRay = get_node("Sprite/WallRay")
onready var FloorRay = get_node("Sprite/FloorRay")

var crawl_inc = 8

var hits = 3

func kill():
	queue_free()

func die():
	kill()

func take_strike( from ):
	self.hits -= 1
	if self.hits <= 0:
		die()


func crawl():
	var floor_check = !FloorRay.is_colliding()
	var wall_check = WallRay.is_colliding()
	
	if floor_check:
		turn_clockwise()
	elif wall_check:
		turn_counterclockwise( WallRay.get_collision_point() )
	
	var motion = get_transform().x.normalized() * crawl_inc
	move(motion)


func turn_clockwise():
#	print("I turn clockwise!")
	var new_pos = get_pos()
	new_pos += Vector2( 8, 16 ).rotated( get_rot() )
	rotate( deg2rad( -90 ) )
	set_pos( new_pos )

func turn_counterclockwise( to_pos ):
#	print("I turn counterclockwise!")
	to_pos -= get_transform().y
	rotate( deg2rad( 90 ) )
	to_pos -= get_transform().y * 8
	set_pos( to_pos )
	

func _on_Hitbox_body_enter( body ):
	if body.is_in_group("player"):
		body.hero_take_strike( self )


func _on_Hitbox_area_enter( area ):
	if area.is_in_group("hero_hurtbox"):
		area._hit( self )
