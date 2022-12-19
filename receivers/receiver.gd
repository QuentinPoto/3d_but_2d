extends Spatial # extend depuis GridMap ?
class_name Receiver

signal movement_end

export var label: String
export var instructions: Dictionary = { "InstructionName": [3] }

export var movement_speed: int = 5
export var is_moving: bool = false # TODO si on veut l'activer au debut du niveau

onready var emitters = $"../../Emitters".get_children() # TODO facon plus simple ?
	
# Function qui va connecter tout les emiters et leurs signaux respectiv au ...
func connect_signals():
	for emitter in emitters:
		emitter.connect("emitter_signal", self, "_signal_handler")

func _ready():
	connect_signals()

func _action(interactionName: String):
	print("receiver action for instruction \"", interactionName, "\"")
	
	if not instructions.has(interactionName):
		return
	print("there is a matching instruction !")
	
	# TODO voir ce qu'on fait avec 


### SIGNAL RECEIVER ###
func _signal_handler(labelInstructions):
	print("signal received: ", labelInstructions)
	if not is_moving and labelInstructions.has(label):
		_action(labelInstructions[label])
