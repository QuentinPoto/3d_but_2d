extends Emitter

const Y_MOVE: float = 0.04


func _lock() -> void:
	._lock()
	$box1.translation.y -= Y_MOVE
	$Timer.start()

"""
func _unlock() -> void:
	._unlock()
	$box1.translation.y += Y_MOVE
"""

func _on_Timer_timeout():
	$box1.translation.y += Y_MOVE
