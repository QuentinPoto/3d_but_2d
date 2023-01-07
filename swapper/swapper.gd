######## Swapper : un Block qui swappe ########
extends Receiver

func _input(event):
	if event.is_action_pressed("on_action") and physics_state == IS_STILL:
		_player_action()

func _player_action():
	if not $RayCasts.is_player_contact():
		return 
	SwapLogic.on_reverse_map()
	$RayCasts.rotation_degrees.x = 180 if !SwapLogic.is_player_down else 0
