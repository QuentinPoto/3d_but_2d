# Swapper : un Block qui swappe
extends StaticBody


func _input(event):
	if event.is_action_pressed("on_action"):
		_player_action()

func _player_action():
	if not $RayCasts.is_player_contact():
		return 
	SwapLogic.on_reverse_map()
	$RayCasts.rotation_degrees.x = 180 if !SwapLogic.is_player_down else 0
