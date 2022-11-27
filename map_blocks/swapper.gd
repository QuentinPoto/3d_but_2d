class_name Swapper
extends StaticBody

func _on_Player_player_action(player_pos: Vector3):
	print("signal received")
	if round(translation.x) == round(player_pos.x) and round(translation.z) == round(player_pos.z):
		print("player is on me")
		SwapLogic.on_reverse_map()
