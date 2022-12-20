extends Spatial # extend depuis GridMap ?
class_name Receiver

############################## SIGNAL & VAR ##############################
signal movement_end_signal

export var label: String
export var instructions: Dictionary = { "InstructionName": [3] }

export var movement_speed: int = 5
export var is_moving: bool = false # TODO|    export si on veut l'activer au debut du niveau

############################## FUNCTION NATIVE ##############################

func _ready():
	_connect_signals()

############################## .?. ##############################

# Function qui va connecter tout les signaux des emiters a self, le receiver
func _connect_signals():
	for emitter in $"../../Emitters".get_children(): # TODO facon plus simple ?
		# TODO : ne connecter que ceux qui partage le label
		# et du coup plus besoin de verifeir derrier !
		emitter.connect("emitter_signal", self, "_signal_handler")


func _action(instructionName: String): ## OVERRIDE
	Log.debug("there is a matching instruction: ", typeof(instructions[instructionName]), instructions[instructionName])
	var instruction = instructions[instructionName]
	# ERROR handling, meilleur facon ? TODO faire crash le programme
	if typeof(instruction) != TYPE_ARRAY:
		Log.error("Le type d'instruction ne fonctionne pas ! (n'est pas une liste...)")
		get_tree().quit()
	if len(instruction) == 0:
		Log.error("ERROR, la liste est vide !")
		get_tree().quit()

	match typeof(instruction[0]):
		TYPE_INT: # rotation
			# TODO
			Log.debug("int")
			pass
		TYPE_VECTOR3: # translation
			# TODO
			Log.debug("vec3")
			pass
		_:
			Log.error("La liste contient un type non gere: ", typeof(instruction[0]))
			get_tree().quit()

	# TODO -> a la fin du movement
	emit_signal("movement_end_signal", label)

############################## SIGNALS RECEIVER ##############################
func _signal_handler(labelInstructions_emitter):
	Log.debug("signal received: ", labelInstructions_emitter)
	
	if is_moving:
		return
	if not labelInstructions_emitter.has(self.label):
		return
	if not instructions.has(labelInstructions_emitter[self.label]):
		Log.error("Pas d'instruction avec ce nom: ", labelInstructions_emitter[self.label])
		return

	_action(labelInstructions_emitter[self.label])














