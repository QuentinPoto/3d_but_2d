extends StaticBody

signal state_change

export var interaction_tags: Array

const Y_MOVEMENT = 0.049

var _is_pressed: bool = false

func _process(delta):
	_check_interaction()

func _check_interaction():
	if $RayCasts.is_player_contact() != _is_pressed:
		_is_pressed = !_is_pressed
		emit_signal("state_change", _is_pressed, interaction_tags)
		translation.y += -Y_MOVEMENT if _is_pressed else Y_MOVEMENT
		# TODO bruitage
