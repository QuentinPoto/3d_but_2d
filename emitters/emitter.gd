extends Spatial
class_name Emitter
# Class abstraite (qui n'est jamais utilisee directement, qui a pour seul but de creer des enfants)
# 	Qui generise les principes commun a tout les emitters. Les voici :
#		- Avoir un dictionnaire des interactions / trucs qu'on veut declancher depuis cet emitter 
#		- 
#		- 
#		- Recoi

############################## SIGNAL & VAR ##############################

signal emitter_signal
export var labelInstructions_emitter: Dictionary = { # TODO rename ?
	"ReceiverLabel": "InstructionName" # valeur par defaut
}
var _is_freeze: bool = false

############################## FUNCTION NATIVE ##############################

func _ready():
	_connect_signals()

func _process(delta):
	_show_keystroke()

func _input(event):
	if event.is_action_pressed("on_action") and _can_interact():
		emit_signal("emitter_signal", labelInstructions_emitter)
		# TODO activation plaque de pression ?


############################## .?. ##############################


func _connect_signals():
	# Connect les signaux des autres emitters et de self
	for emitter in get_parent().get_children():
		emitter.connect("emitter_signal", self, "_on_emitter_signal")

	# Connect les signaux "de fin" des receivers
	for receiver in $"../../Receivers".get_children():
		receiver.connect("movement_end_signal", self, "_on_movement_end_signal")

func _show_keystroke() -> void:	# TODO opti pour qu'il ne refasse pas le calcul a chaque fois ??
	# Verifie que l'emetteur possede un label "Keystroke" a afficher
	# Et qu'il y'a les raycasts nescessaire a la detection du joueur
	if get_node_or_null('Keystroke') == null or \
		get_node_or_null('RayCasts') == null:
		return
	$Keystroke.visible = _can_interact()

func _can_interact() -> bool:
	return not _is_freeze and $RayCasts.is_player_contact()

func _share_label(otherlabelInstructions_emitter) -> bool:
	if labelInstructions_emitter == otherlabelInstructions_emitter:
		return true
	for label in labelInstructions_emitter.keys():
		if otherlabelInstructions_emitter.has(label):
			return true
	return false

func _freeze() -> void: ## OVERRIDE
	_is_freeze = true

func _unfreeze() -> void: ## OVERRIDE
	_is_freeze = false

############################## SIGNALS RECEIVER ##############################
# permet de freeze lui-meme et ceux qui partage un des label
func _on_emitter_signal(otherlabelInstructions_emitter):
	Log.debug(self.name, ": otherlabelInstructions_emitter", otherlabelInstructions_emitter)
	if not _share_label(otherlabelInstructions_emitter):
		return
	Log.debug(self.name, "freeze by imeself or emitter who share what we want")
	
	_freeze()

func _on_movement_end_signal(label): ## OVERRIDE
	# verifie que ca s'adresse bien a lui
	if not labelInstructions_emitter.has(label):
		return
	Log.debug("_on_movement_end_signal received !")
	_unfreeze() # TODO ca marche plus




