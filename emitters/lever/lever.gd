extends Emitter


func _lock() -> void:
	._lock() # ca appel la method qu'on override !
	$Sprite3D.flip_h = true

func _unlock() -> void:
	._unlock()
	$Sprite3D.flip_h = false

#func _on_movement_end_signal(label) -> void:
#	._on_movement_end_signal(label)
