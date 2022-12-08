class_name Swapper
extends StaticBody

# Swapper : un Block qui swappe
func _on_Player_player_action(player_pos: Vector3):
	# masque la hauteur
	player_pos.y = translation.y
	# compare les autres coordonees
	if translation.round() == player_pos.round():
		SwapLogic.on_reverse_map()
