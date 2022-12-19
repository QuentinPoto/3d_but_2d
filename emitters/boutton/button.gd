extends Emitter


onready var _initial_box1_y_translation: float = $box1.translation.y
const Y_MOVE: float = 0.015

func _player_action() -> void:
	print("player action")
	$box1.translation.y -= Y_MOVE

func _on_rotation_end() -> void:
	print("rotation end")	
	$box1.translation.y = _initial_box1_y_translation
