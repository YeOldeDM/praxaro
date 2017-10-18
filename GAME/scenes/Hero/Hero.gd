extends KinematicBody2D



var facing = 1 setget _set_facing


var velocity = Vector2()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	### SETUP ###
	var new_facing = self.facing
	# Create force
	var force = Vector2()
	
	
	
	### INPUT ###
	
	# Grab input
	var LEFT = Input.is_action_pressed("LEFT")
	var RIGHT = Input.is_action_pressed("RIGHT")
	var UP = Input.is_action_pressed("UP")
	var DOWN = Input.is_action_pressed("DOWN")
	var JUMP = Input.is_action_pressed("JUMP")
	var SHOOT = Input.is_action_pressed("STRIKE")
	
	
	# Covert directional input into a Vector
	var INPUT = Vector2( RIGHT - LEFT, DOWN - UP )
	var vsign = sign(velocity.x)
	var vlen = abs(velocity.x)
	
	
	### FORCES ###
	
	# Define Aceleration/Deceleration to use
	# If we can move and horizontal input is positive:
		# Acelerate up to max speed or change direction
	# otherwise decelerate toward zero speed
	
	# Jump
	
	# Kill upward vertical movement if JUMP control is let go
	
	
	### DIRECT MOTION ###
	
	# Integrate force into velocity
	# Turn velocity into motion
	
	
	### COLLISION HANDLING ###
	
	
	
	### PREP NEXT FRAME ###
	
	
	
	
	
func _set_facing(what):
	facing = what
	if has_node("Sprite"):
		get_node("Sprite").set_scale( Vector2( facing, 1 ) )