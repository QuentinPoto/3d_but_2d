extends Spatial

signal button_signal
var signal_name = "button_signal" # TODO avoir le meme nom partout ??

export var interaction_tags: Dictionary

var _is_freeze: bool = false
onready var _initial_box1_y_translation: float = $box1.translation.y
const Y_MOVE: float = 0.015

func _process(delta):
	# TODO opti pour qu'il ne refasse pas le calcul a chaque fois ??
	$Label3D.visible = $RayCasts.is_player_contact()

func _input(event):
	if event.is_action_pressed("on_action"):
		_player_action()
		
func _player_action() -> void:
	if not _is_freeze and $RayCasts.is_player_contact():
		emit_signal("button_signal", null, interaction_tags)
		_is_freeze = true
		$box1.translation.y -= Y_MOVE

### SIGNALS RECEIVER ###
func _on_Rotationnal_rotation_end():
	_is_freeze = false
	$box1.translation.y = _initial_box1_y_translation
