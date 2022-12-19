# Class abstraite (qui n'est jamais utilisee directement, qui a pour seul but de creer des enfants)
# 	Qui generise les principes commun a tout les emitters. Les voici :
#		- Avoir un dictionnaire des interactions / trucs qu'on veut declancher depuis cet emitter 
#		- 
#		- 
#		- Recoi

extends Spatial
class_name Emitter


signal emitter_signal


# TODO : trouver un meilleur nom que "signals ?", genre send / interaction_tag
export var labelInstructions: Dictionary = { 
	"ReceiverLabel": "InstructionName" # valeur par defaut
}

var _is_freeze: bool = false		# si l'emeteur peut bouger 


### Function native ###
func _process(delta):
	_show_keystroke()

func _input(event):
	if event.is_action_pressed("on_action") and _can_interact():
		# TODO definir 
		emit_signal("emitter_signal", labelInstructions)
		_player_action()
		_is_freeze = true

### ... ###
func _show_keystroke() -> void:
	# TODO opti pour qu'il ne refasse pas le calcul a chaque fois ??
	
	# Verifie que l'emetteur possede un label "Keystroke" a afficher
	# Et qu'il y'a les raycasts nescessaire a la detection du joueur
	if get_node_or_null('Keystroke') == null or get_node_or_null('RayCasts') == null:
		return
	$Keystroke.visible = $RayCasts.is_player_contact()

func _can_interact() -> bool:
	return not _is_freeze and $RayCasts.is_player_contact()

### SIGNALS RECEIVER ###
func _on_rotation_end_signal():
	_on_rotation_end()
	_is_freeze = false

### To override ###
func _on_rotation_end() -> void: pass
func _player_action() -> void: pass
