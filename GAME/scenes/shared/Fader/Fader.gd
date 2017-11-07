extends WorldEnvironment

signal fade_finished()

var FADE_SPEED = 3

var F = 1.0
var dir = -1

onready var env = get_environment()

func fade_in():
	F = 0.0
	dir = 1.0
	call_deferred("set_process", true)

func fade_out():
	F = 1.0
	dir = -1.0
	call_deferred("set_process", true)

func _process(delta):
	F += dir * delta * FADE_SPEED
	
	var b = lerp( 0.01, 1.0, F )
	var c = lerp( 1.0, 8.0, 1-F )
	
	env.fx_set_param( env.FX_PARAM_BCS_BRIGHTNESS, b )
	env.fx_set_param( env.FX_PARAM_BCS_CONTRAST, c )
	
	if dir == 1 and F >= 1.0:
		env.fx_set_param( env.FX_PARAM_BCS_BRIGHTNESS, 1 )
		env.fx_set_param( env.FX_PARAM_BCS_CONTRAST, 1 )
		emit_signal("fade_finished")
		set_process(false)
	elif dir == -1 and  F <= 0.0:
		env.fx_set_param( env.FX_PARAM_BCS_BRIGHTNESS, 0.01 )
		env.fx_set_param( env.FX_PARAM_BCS_CONTRAST, 8.0 )
		emit_signal("fade_finished")
		set_process(false)


