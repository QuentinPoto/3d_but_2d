extends Spatial # extend depuis GridMap ?
class_name Receiver

signal movement_end_signal

export var label: String
export var instructions: Dictionary = { "InstructionName": [3] }

export var movement_speed: int = 5
export var is_moving: bool = false # TODO export, si on veut l'activer au debut du niveau

onready var emitters = $"../../Emitters".get_children() # TODO facon plus simple ?

func _ready():
	connect_signals()

# Function qui va connecter tout les emiters et leurs signaux respectiv au ...
func connect_signals():
	for emitter in emitters:
		emitter.connect("emitter_signal", self, "_signal_handler")






### SIGNAL RECEIVER ###
func _signal_handler(labelInstructions):
	print("signal received: ", labelInstructions)
	if not is_moving and labelInstructions.has(label):
		_action(labelInstructions[label])

### Generic method / class functions ###
func _action(interactionName: String):
	print("receiver action for instruction \"", interactionName, "\"")
	
	if not instructions.has(interactionName):
		return
	print("there is a matching instruction: ", typeof(instructions[interactionName]), instructions[interactionName])
	var instruction = instructions[interactionName]
	# ERROR handling, meilleur facon ? TODO faire crash le programme
	if typeof(instruction) != TYPE_ARRAY:
		print("ERROR, le type d'instruction ne fonctionne pas ! (n'est pas une liste...)")
		return
	if len(instruction) == 0:
		print("ERROR, la liste est vide !")
		return

	match typeof(instruction[0]):
		TYPE_INT: # rotation
			# TODO
			print("int")
		TYPE_VECTOR3: # translation
			# TODO
			print("vec3")
		_:
			print("ERROR, la liste contient un type non gere: ", typeof(instruction[0]))
			return
	
	# call a function that each different child of this class can override
	_custom_action()
	
	# TODO -> a la fin du movement
	emit_signal("movement_end_signal", label)

### To override ###
func _custom_action() -> void: pass
