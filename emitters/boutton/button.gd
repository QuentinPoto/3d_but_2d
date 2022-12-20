extends Emitter

onready var _initial_box1_y_translation = $box1.translation.y
const Y_MOVE: float = 0.015

func _freeze() -> void:
	._freeze() # ca appel la method qu'on override !
	$box1.translation.y -= Y_MOVE

func _unfreeze() -> void:
	._unfreeze()
	$box1.translation.y = _initial_box1_y_translation

func _on_movement_end_signal(label) -> void:
	._on_movement_end_signal(label)
