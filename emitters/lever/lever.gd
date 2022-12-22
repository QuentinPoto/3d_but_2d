extends Emitter


func _lock() -> void:
	._lock()
	$Sprite3D.flip_h = not $Sprite3D.flip_h
