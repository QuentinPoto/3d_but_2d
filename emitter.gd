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

func _ready():
	_connect_signals()
	
### ... ###
onready var receivers = $"../../Receivers".get_children()
onready var emitters = get_parent().get_children()
func _connect_signals():
	for emitter in emitters:
		emitter.connect("emitter_signal", self, "")
	# connect le signal de fin
	for receiver in receivers:
		receiver.connect("movement_end_signal", self, "_on_movement_end_signal")

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
func _on_movement_end_signal(label):
	# verifie que ca s'adresse bien a lui
	if not labelInstructions.has(label):
		return
	print("_on_movement_end_signal received !")
	_on_rotation_end()
	_is_freeze = false

# TODO ne marche pas encore !!!!!
func _share_label(otherLabelInstructions) -> bool:
	if labelInstructions == otherLabelInstructions:
		return true
	for label in labelInstructions.keys():
		if otherLabelInstructions.has(label):
			return true
	return false

# permet de freeze lui-meme et ceux qui partage un des label
func _on_emitter_siganl(otherLabelInstructions):
	if not _share_label(otherLabelInstructions):
		return
	print("freeze by imeself or emitter who share what we want")
	_is_freeze = true
	
### To override ###
func _on_rotation_end() -> void: pass
func _player_action() -> void: pass
