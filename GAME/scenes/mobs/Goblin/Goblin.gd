extends KinematicBody2D

var facing = 1 setget _set_facing

var hits = 3

var walk_speed = 6

var turn_time = 0

func start():
	set_fixed_process(true)

func kill():
	queue_free()

func die():
	kill()

func take_strike( from ):
#	self.hits -= 1
	if self.hits <= 0:	die()


func _ready():
	start()


func _fixed_process( delta ):
	var new_facing = self.facing
	
	var x = self.walk_speed * self.facing * delta
	var force = Vector2( x, 0 )
	move(force)
	
	var hits_wall = get_node("Sprite/WallRay").is_colliding()
	var floor_rays = int( get_node("FloorRays/Right").is_colliding() ) - int( get_node("FloorRays/Left").is_colliding() )
	
	if hits_wall:
		new_facing = -self.facing
		turn_time = 0
	
	elif floor_rays != 0 and turn_time > delta*2:
		new_facing = -self.facing
		turn_time = 0
	
	if new_facing != self.facing:
		self.facing = new_facing
	
	turn_time += delta

func _set_facing( what ):
	facing = what
	get_node("Sprite").set_scale( Vector2( facing, 1 ) )


func _on_Hurtbox_body_enter( body ):
	if body.has_method("hero_take_strike"):
		body.hero_take_strike( self )
