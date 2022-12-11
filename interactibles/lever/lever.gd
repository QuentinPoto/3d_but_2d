class_name Lever
extends Spatial
export var lever_number: int
export var interaction_tag: String

signal lever_signal

# Lever : un interactible booléen
func _on_Player_player_action(player_pos: Vector3):
	# masque la hauteur
	player_pos.y = translation.y
	# compare les autres coordonees
	if translation.round() == player_pos.round():
		$Sprite3D.flip_h = not $Sprite3D.flip_h
		# emit lever_signal, with bool "is flipped", and interaction_tag
		emit_signal("lever_signal", $Sprite3D.flip_v, "rotate_1")
