extends PanelContainer

const PARAM_PATH = "res://scenes/HeroDebugMenu/HeroDebugParam/HeroDebugParam.tscn" 

onready var params_box = get_node( "box/Params/scroll/box" )

var hero

func set_param( member, value ):
	if hero:
		if member in hero:
			hero.set( member, value )


func populate_params( from_data ):
	for dict in from_data:
		var new_params = preload( PARAM_PATH ).instance()
		params_box.add_child( new_params )
		new_params.menu = self
		new_params.init( dict["member"], dict["min"], dict["max"], dict["step"], dict["value"] )
