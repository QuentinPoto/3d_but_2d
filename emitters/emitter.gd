extends Spatial
class_name Emitter
# Class abstraite (qui n'est jamais utilisee directement, qui a pour seul but de creer des enfants)
# 	Qui generise les principes commun a tout les emitters. Les voici :
#		- Avoir un dictionnaire des interactions / trucs qu'on veut declancher depuis cet emitter 
#		- {receiver: action}
#		- 
#		- Recoi

############################## SIGNAL & VAR ##############################

signal emitter_signal
export var commands_dict: Dictionary = {}
var _locked: bool = false

############################## FUNCTION NATIVE ##############################

func _ready():
	_connect_signals()

func _process(_delta):
	_show_keystroke()

func _input(event):
	if event.is_action_pressed("on_action") and _can_interact():
		Log.info("send signal")
		emit_signal("emitter_signal", commands_dict)
		# TODO activation plaque de pression ?


############################## .?. ##############################


func _connect_signals():
	print(self.name)
	for emitter in get_parent().get_children():
		Log.info(emitter.name)
		Log.info(emitter.commands_dict)
		for key in self.commands_dict.keys():
			if emitter.commands_dict.has(key):
				# Connecte(Soi -> Emitters)  "emitter_signal"
				emitter.connect("emitter_signal", self, "_on_emitter_signal")
	
	for receiver in $"../../Receivers".get_children():
		if self.commands_dict.keys().has(receiver.label):
			# Connecte (Receivers -> Soi)  "end_signal"
			receiver.connect("movement_end_signal", self, "_on_movement_end_signal")
			# Connecte (Soi -> Receivers)  "emitter_signal"
			self.connect("emitter_signal", receiver, "_signal_handler")
		
		for receiver_child in receiver.get_children():
			if self.commands_dict.keys().has(receiver_child.label):
				# Connecte (Receiver_child -> Soi)  "end_signal"
				receiver_child.connect("movement_end_signal", self, "_on_movement_end_signal")
				# Connecte (Soi -> Receiver_child)  "emitter_signal"
				self.connect("emitter_signal", receiver_child, "_signal_handler")


func _show_keystroke() -> void:	# TODO opti pour qu'il ne refasse pas le calcul a chaque fois ??
	# Verifie que l'emetteur possede un label "Keystroke" a afficher
	# Et qu'il y'a les raycasts nescessaire a la detection du joueur
	if get_node_or_null('Keystroke') == null or \
		get_node_or_null('RayCasts') == null:
		return
	$Keystroke.visible = _can_interact()

func _can_interact() -> bool:
	return not _locked and $RayCasts.is_player_contact()

func _share_label(othercommands_dict) -> bool:
	if commands_dict == othercommands_dict:
		return true
	for label in commands_dict.keys():
		if othercommands_dict.has(label):
			return true
	return false


############################## SIGNALS RECEIVER ##############################
# permet de freeze lui-meme et ceux qui partage un des label
func _on_emitter_signal(othercommands_dict):
	Log.debug(self.name, ": othercommands_dict", othercommands_dict)
	Log.debug(self.name, "freeze by imeself or emitter who share what we want")
	
	_lock()

func _on_movement_end_signal(label): ## OVERRIDE
	Log.debug("_on_movement_end_signal received !")
	
	_unlock() # TODO ca marche plus


func _lock(): _locked = true

func _unlock(): _locked = false

