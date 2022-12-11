extends Spatial

signal lever_signal

export var interaction_tags: Array

var _is_freeze: bool = false


func _process(delta):
	# TODO opti pour qu'il ne refasse pas le calcul a chaque fois ??
	$Label3D.visible = $RayCasts.is_player_contact()

func _input(event):
	if event.is_action_pressed("on_action"):
		_player_action()
		
func _player_action() -> void:
	if not _is_freeze and $RayCasts.is_player_contact():
		$Sprite3D.flip_h = not $Sprite3D.flip_h
		# emit lever_signal, with bool "is flipped", and interaction_tag
		emit_signal("lever_signal", $Sprite3D.flip_v, interaction_tags)
		_is_freeze = true

### SIGNALS RECEIVER ###
func _on_Rotationnal_rotation_end():
	_is_freeze = false
