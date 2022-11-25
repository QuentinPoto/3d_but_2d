class_name Swapper
extends MeshInstance

func _on_Player_player_action(player_pos: Vector3):
	if translation.x == player_pos.x and translation.z == player_pos.z:
		SwapLogic.on_reverse_map()
