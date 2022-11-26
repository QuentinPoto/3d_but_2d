class_name Swapper
extends MeshInstance

func _on_Player_player_action(player_pos: Vector3):
	if round(translation.x) == round(player_pos.x) and round(translation.z) == round(player_pos.z):
		SwapLogic.on_reverse_map()
