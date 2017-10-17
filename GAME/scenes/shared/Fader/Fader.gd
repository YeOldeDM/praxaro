extends WorldEnvironment

signal fade_finished()

var F = 1.0
var dir = -1

onready var env = get_environment()

func fade_in():
	print("fading in")
	F = 0.0
	dir = 1
	set_process(true)

func fade_out():
	print("fading out")
	F = 1.0
	dir = -1
	set_process(true)

func _process(delta):
	F += dir * delta
	
	var b = lerp( 0.01, 1.0, F )
	var c = lerp( 1.0, 8.0, 1-F )
	
	env.fx_set_param( env.FX_PARAM_BCS_BRIGHTNESS, b )
	env.fx_set_param( env.FX_PARAM_BCS_CONTRAST, c )
	
	if dir == 1 and F >= 1.0:
		emit_signal("fade_finished")
		set_process(false)
	elif dir == -1 and  F <= 0.01:
		emit_signal("fade_finished")
		set_process(false)
		


	