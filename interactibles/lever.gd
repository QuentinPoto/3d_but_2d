class_name Lever
extends Spatial
export var lever_number: int

# Lever : un interactible booléen
func _on_Player_player_action(player_pos: Vector3):
	print("received")
	# masque la hauteur
	player_pos.y = translation.y
	# compare les autres coordonees
	if translation.round() == player_pos.round():
		$Sprite3D.flip_h = not $Sprite3D.flip_h
		print($Sprite3D.flip_h)
		emit_signal("lever_signal", lever_number, $Sprite3D.flip_v)
