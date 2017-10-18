extends KinematicBody2D

var RISING_GRAVITY = 350
var FALLING_GRAVITY = 800


var AIR_MIN_TIME = 0.2	# The min amount of sec you must be airborne to be considered "in the air"

# horizontal Acceleration forces
var FLOOR_MOVE_FORCE = 800
var AIR_MOVE_FORCE = 700
# horizontal Deceleration forces
var FLOOR_STOP_FORCE = 600
var AIR_STOP_FORCE = 250
# Max speeds
var MAX_SPEED = Vector2(200, 600)

var JUMP_FORCE = 300
var JUMP_STOP_FORCE = 750


var facing = 1 setget _set_facing


var velocity = Vector2()

var pressed = {
	"JUMP":	false,
	"STRIKE":	false,
	}

var airtime = 0





func is_in_air():
	return self.airtime >= AIR_MIN_TIME

func is_on_ground():
	return self.airtime <= 0.0






func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	### SETUP ###
	var hit_ground = false
	var new_facing = self.facing
	# Create force
	var G = FALLING_GRAVITY if velocity.y > 0 else RISING_GRAVITY
	var force = Vector2(0,G * int( is_in_air() ) )
	
	
	
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
	if is_colliding():
		var N = get_collision_normal()
		var A = rad2deg(acos(N.dot(Vector2(0, -1))))
		if A <= 20:
			self.airtime = 0
	
	
	### PREP NEXT FRAME ###
	pressed.JUMP = JUMP
	pressed.STRIKE = STRIKE
	if !hit_ground:
		self.airtime += delta
	
	
	
	
func _set_facing(what):
	facing = what
	if has_node("Sprite"):
		get_node("Sprite").set_scale( Vector2( facing, 1 ) )