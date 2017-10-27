extends KinematicBody2D

# Personal Gravity forces

var RISING_GRAVITY = 480	# while velocity.y < MIN_FALLING_VELOCITY
var FALLING_GRAVITY = 800	# while velocity.y > MIN_FALLING_VELOCITY


# The min amount of sec you must be airborne to be considered "in the air"
var AIR_MIN_TIME = 0.12
# Min velocity.y to be considered "falling"
var MIN_FALLING_VELOCITY = 4

# horizontal Acceleration forces
var FLOOR_MOVE_FORCE = 800
var AIR_MOVE_FORCE = 600
# horizontal Deceleration forces
var FLOOR_STOP_FORCE = 900
var AIR_STOP_FORCE = 250
# Max speeds
var MAX_SPEED = 68
# Jump forces
var JUMP_FORCE = 245
var JUMP_STOP_FORCE = 12


# Facing property
var facing = 1 setget _set_facing
# Animation property
var anim = "idle" setget _set_anim

# Current velocity
var velocity = Vector2()
# External ( kickback ) forces
var ext_force = Vector2()

# Key pulse flags
# (hack until we have is_action_just_pressed)
var pressed = {
	"JUMP":	false,
	"STRIKE":	false,
	"UP":	false,
	}

# State flags
var can_move = true
var is_striking = false
var jumping = false

# Seconds spent airborne
var airtime = 0

# reference to a portal we're standing in front of
# set/unset by that portal
var portal = null

# Reference to World, set by World
var world	






# Initialize the Hero
# (Should be called "start()"?)
func init( to_level ):
	get_node("Camera").set_limits( to_level.get_boundry_rect() )
	self.can_move = true

# Check if we're in the air
func is_in_air():
	return self.airtime >= AIR_MIN_TIME

# Check if we're on the ground
func is_on_ground():
	return self.airtime <= AIR_MIN_TIME

# Return big debug param dictionary for HeroDebugMode
func get_debug_params():
	return [
	{ "member": "RISING_GRAVITY", "value": RISING_GRAVITY, "min": 10, "max": 5000, "step": 10 },
	{ "member": "FALLING_GRAVITY", "value": FALLING_GRAVITY, "min": 10, "max": 5000, "step": 10 },
	{ "member": "FLOOR_MOVE_FORCE", "value": FLOOR_MOVE_FORCE, "min": 10, "max": 2000, "step": 1 },
	{ "member": "AIR_MOVE_FORCE", "value": AIR_MOVE_FORCE, "min": 10, "max": 2000, "step": 1 },
	{ "member": "FLOOR_STOP_FORCE", "value": FLOOR_STOP_FORCE, "min": 10, "max": 2000, "step": 1 },
	{ "member": "AIR_STOP_FORCE", "value": AIR_STOP_FORCE, "min": 10, "max": 2000, "step": 1 },
	{ "member": "MAX_SPEED", "value": FLOOR_STOP_FORCE, "min": 10, "max": 200, "step": 1 },
	{ "member": "JUMP_FORCE", "value": JUMP_FORCE, "min": 10, "max": 500, "step": 1 },
	{ "member": "JUMP_STOP_FORCE", "value": JUMP_STOP_FORCE, "min": 10, "max": 500, "step": 1 },
	]

# Special take_strike method unique to Me
func hero_take_strike( from ):
	print( "I am hurt by %s!" % from.get_name() )
	if world.debug_mode.DevMode:
		if world.debug_mode.GodMode:
			print( "I am sparta!" )
	else:
		print( "OW!" )

# Initialize a STRIKE state
# ("strike" animation should be set
# alongside this call)
func begin_strike():
	self.is_striking = true

# Create the STRIKE hurtbox
# called by "strike" animation
func make_strike():
	var slash = preload("res://scenes/shared/Hurtboxes/SwordSlash/SwordSlash.tscn").instance()
	add_child(slash)
	slash.set_scale( Vector2( self.facing, 1 ) )
	slash.start( self )

# End a STRIKE state
# called by the last frame of the "strike" animation
func end_strike():
	self.is_striking = false
	self.anim = "idle"


func _ready():
	set_fixed_process(true)


###		HERO PROCESS LOOP	###
func _fixed_process(delta):
	### SETUP ###
	var hit_ground = false
	var new_facing = self.facing
	var new_anim = self.anim
	# Create force
	var G = FALLING_GRAVITY if velocity.y > MIN_FALLING_VELOCITY else RISING_GRAVITY
	var force = Vector2( 0, G * int( !world.debug_mode.GhostMode ) )
	
	
	
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
	if is_on_ground() and is_striking:
		INPUT.x = 0
	var vsign = sign(velocity.x)
	var vlen = abs(velocity.x)
	
	
	
	### ALTER FORCES ###
	
	# Define Aceleration/Deceleration to use
	var A = FLOOR_MOVE_FORCE if is_on_ground() else AIR_MOVE_FORCE
	var D = FLOOR_STOP_FORCE if is_on_ground() else AIR_STOP_FORCE
	# If we can move and horizontal input is positive:
	if abs(INPUT.x) == 1:
		# Acelerate up to max speed or change direction
		if vlen < MAX_SPEED or vsign != INPUT.x:
			force.x += INPUT.x * A
		# update new facing
		new_facing = INPUT.x

	# otherwise decelerate toward zero speed
	else:
		vlen = max( 0, vlen - ( D * delta ) )
		velocity.x = vlen * vsign

	
	if world.debug_mode.GhostMode:
		if JUMP: INPUT.y = -1
		var ylen = abs(velocity.y)
		var ysign = sign(velocity.y)
		if abs(INPUT.y) == 1:
			if ylen < MAX_SPEED or ysign != INPUT.y:
				force.y += INPUT.y * A
		else:
			ylen = max( 0, ylen - ( D * delta ) )
			velocity.y = ylen * ysign
	
	
	### DIRECT MOTION ###
	# Integrate force into velocity
	velocity += force * delta
	if ext_force.length() > 1:
		velocity += ext_force
		ext_force = Vector2()
	else:
		ext_force *= 0.95
	# Turn velocity into motion
#	velocity.y = min( velocity.y, MAX_SPEED )
	var motion = move( velocity * delta )
	
	
	### COLLISION HANDLING ###
	if is_colliding():
		print( get_collider_metadata() )
		var N = get_collision_normal()
		var A = rad2deg(acos(N.dot(Vector2(0, -1))))
		if A <= 20:
			self.airtime = 0
			if self.jumping:
				self.jumping = false
			if !is_striking:
				if abs(velocity.x) > 1:
					new_anim = "walk"
				else:
					new_anim = "idle"

		
		velocity = N.slide( velocity )
		motion = N.slide( motion )
		move(motion)
		
	else:
		if !is_striking:
			new_anim = "jump"
	
	
	### JUMPING ###
	if not world.debug_mode.GhostMode:
		if JUMP and !pressed.JUMP and not jumping and is_on_ground() and can_move:
			velocity.y = -JUMP_FORCE
			self.jumping = true

		# Kill upward vertical movement if JUMP control is let go
		if jumping and !JUMP and is_in_air() and velocity.y < -JUMP_STOP_FORCE:
			velocity.y = JUMP_STOP_FORCE#+= JUMP_STOP_FORCE * delta
	
	### STRIKING ###
	if STRIKE and !pressed.STRIKE and !is_striking:
		begin_strike()
		new_anim = "strike"
	
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
	
	# Set changed properties
	if new_facing != self.facing:
		self.facing = new_facing
	
	if new_anim != self.anim:
		self.anim = new_anim

	



###	SETTERS	###

func _set_facing(what):
	facing = what
	if has_node("Sprite"):
		get_node("Sprite").set_scale( Vector2( facing, 1 ) )

func _set_anim( what ):
	anim = what
	if has_node("Animator"):
		get_node("Animator").play( anim )
	print(anim)