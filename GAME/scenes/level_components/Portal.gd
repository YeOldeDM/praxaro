extends Area2D

export(String, FILE, "*.tscn") var target_level
export(String) var target_point

func Use():
	get_owner().game.set_level( self.target_level, self.target_point )

func _ready():
	pass


func _on_Portal_body_enter( body ):
	if body.is_in_group("player"):
		if !body.portal == self:
			body.portal = self
			print("enter!")


func _on_Portal_body_exit( body ):
	if body.is_in_group("player"):
		if body.portal == self:
			body.portal = null
			print("leave!")
