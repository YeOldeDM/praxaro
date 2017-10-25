extends VBoxContainer

var menu

var member = "hotdog" setget _set_member

var min_value = 0 setget _set_min_value
var max_value = 100 setget _set_max_value
var step = 1 setget _set_step
var value = 50 setget _set_value

func init( member, MIN, MAX, STEP, VAL ):
	self.member = member
	self.min_value = MIN
	self.max_value = MAX
	self.step = STEP
	self.value = VAL

func _set_member( what ):
	member = what
	get_node("ParamName").set_text( member.to_lower() )

func _set_min_value( what ):
	min_value = what
	get_node("ValueSpinner").set_min( min_value )
	get_node("ValueSlider").set_min( min_value )

func _set_max_value( what ):
	min_value = what
	get_node("ValueSpinner").set_max( min_value )
	get_node("ValueSlider").set_max( min_value )

func _set_step( what ):
	step = what
	get_node("ValueSpinner").set_step( step )
	get_node("ValueSlider").set_step( step )

func _set_value( what ):
	value = what
	get_node("ValueSpinner").set_value( value )
	get_node("ValueSlider").set_value( value )
	if menu:
		menu.set_param( self.member, value )



func _on_ValueSpinner_value_changed( value ):
	self.value = value


func _on_ValueSlider_value_changed( value ):
	self.value = value
