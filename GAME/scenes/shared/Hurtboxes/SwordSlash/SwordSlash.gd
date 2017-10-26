extends Area2D

var owner

var anims = [ "slash1","slash2" ]

var strike_kickback = 180

func start( from, anim=0 ):
	self.owner = from
	anim = clamp( anim, 0, anims.size()-1 )
	get_node("Sprite").show()
	get_node("Animator").play( anims[ anim ] )




func _strike():
	var hits = get_overlapping_bodies()
	for body in hits:
		if body != owner:
			if body.has_method("take_strike"):
				_hit( body )
				

func _hit( body ):
	body.take_strike( self )
	var va = -( body.get_pos() - owner.get_pos() ).normalized()
	va *= self.strike_kickback
	owner.ext_force += va
	owner.get_node("Camera").shake( 2 )
	
	var blood = preload("res://scenes/shared/Gore/BloodSpray.tscn").instance()
	body.get_parent().add_child(blood)
	blood.set_pos( body.get_pos() )
	blood.set_scale( Vector2( sign(va.x), 1 ) )
	blood.set_rot( deg2rad( rand_range( -5, 5 ) ) )