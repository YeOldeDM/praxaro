extends Area2D

var owner

var anims = [ "slash1","slash2" ]



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
				body.take_strike( self )

