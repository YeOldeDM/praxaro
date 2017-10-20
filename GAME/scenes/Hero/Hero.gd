extends KinematicBody2D

var RISING_GRAVITY = 480
var FALLING_GRAVITY = 800
var MIN_FALLING_VELOCITY = 0

var AIR_MIN_TIME = 0.2	# The min amount of sec you must be airborne to be considered "in the air"

# horizontal Acceleration forces
var FLOOR_MOVE_FORCE = 800
var AIR_MOVE_FORCE = 700
# horizontal Deceleration forces
var FLOOR_STOP_FORCE = 600
var AIR_STOP_FORCE = 250
# Max speeds
var MAX_SPEED = Vector2(60, 600)

var JUMP_FORCE = 245
var JUMP_STOP_FORCE = 12


var facing = 1 setget _set_facing


var velocity = Vector2()

var pressed = {
	"JUMP":	false,
	"STRIKE":	false,
	"UP":	false,
	}

var can_move = true

var airtime = 0
var jumping = false

var portal	# reference to a portal we're standing in front of

func init( to_level ):
	get_node("Camera").set_limits( to_level.get_boundry_rect() )
	self.can_move = true

func is_in_air():
	return self.airtime >= AIR_MIN_TIME

func is_on_ground():
	return self.airtime <= AIR_MIN_TIME






func _ready():
	set_fixed_process(true)


func _fixed_process(delta):
	### SETUP ###
	var hit_ground = false
	var new_facing = self.facing
	# Create force
	var G = FALLING_GRAVITY if velocity.y > MIN_FALLING_VELOCITY else RISING_GRAVITY
	var force = Vector2(0,G )
	
	
	
	### INPUT ###
	
	# Grab input
	var LEFT = Input.is_action_pressed("LEFT")
	var RIGHT = Input.is_action_pressed("RIGHT")
	var UP = Input.is_action_pressed("UP")
	var DOWN = Input.is_action_pressed("DOWN")
	var JUMP = Input.is_action_pressed("JUMP")
	var STRIKE = Input.is_action_pressed("STRIKE")
	
	
	# Covert directional input into a Vector
	var INPUT = Vector2( RIGHT - LEFT, DOWN - UP ) * int(self.can_move) 
	var vsign = sign(velocity.x)
	var vlen = abs(velocity.x)
	
	
	### FORCES ###
	
	# Define Aceleration/Deceleration to use
	var A = FLOOR_MOVE_FORCE if is_on_ground() else AIR_MOVE_FORCE
	var D = FLOOR_STOP_FORCE if is_on_ground() else AIR_STOP_FORCE
	# If we can move and horizontal input is positive:
	if abs(INPUT.x) == 1:
		# Acelerate up to max speed or change direction
		if vlen < MAX_SPEED.x or vsign != INPUT.x:
			force.x += INPUT.x * A
		# update new facing
		new_facing = INPUT.x
	# otherwise decelerate toward zero speed
	else:
		vlen = max( 0, vlen - ( D * delta ) )
		velocity.x = vlen * vsign
	
	
	
	### DIRECT MOTION ###
	
	# Integrate force into velocity
	velocity += force * delta
	# Turn velocity into motion
#	velocity.y = min( velocity.y, MAX_SPEED.y )
	var motion = move( velocity * delta )
	
	
	### COLLISION HANDLING ###
	if is_colliding():
		var N = get_collision_normal()
		var A = rad2deg(acos(N.dot(Vector2(0, -1))))
		if A <= 20:
			self.airtime = 0
			if self.jumping:
				self.jumping = false
		
		velocity = N.slide( velocity )
		motion = N.slide( motion )
		move(motion)
	
	# Jump
	if JUMP and !pressed.JUMP and not jumping and is_on_ground() and can_move:
		velocity.y = -JUMP_FORCE
		self.jumping = true
	# Kill upward vertical movement if JUMP control is let go
	if jumping and !JUMP and is_in_air() and velocity.y < -JUMP_STOP_FORCE:
		velocity.y = JUMP_STOP_FORCE#+= JUMP_STOP_FORCE * delta
	
	# Use w/ UP
	if !pressed.UP and INPUT == Vector2(0,-1):
		if self.portal and is_on_ground():
			self.portal.Use()
	
	### PREP NEXT FRAME ###
	pressed.JUMP = JUMP
	pressed.STRIKE = STRIKE
	pressed.UP = UP
	
	if not hit_ground:
		self.airtime += delta
	
	if new_facing != self.facing:
		self.facing = new_facing
	
	get_node("Vel").set_text( str( int( velocity.x ) ) +", "+ str( int( velocity.y ) ) )
	if is_in_air() and velocity.y < 0:
		print(int(velocity.y))
	
	
func _set_facing(what):
	facing = what
	if has_node("Sprite"):
		get_node("Sprite").set_scale( Vector2( facing, 1 ) )