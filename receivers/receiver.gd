extends Spatial # extend depuis GridMap ?
class_name Receiver

############################## SIGNAL & VAR ##############################
signal movement_end_signal

export var label: String
export var instructions: Dictionary = {}  # { "InstructionName": [3] }

export var movement_speed: int = 2
export var rotation_speed: int = 100

enum {
	IS_STILL = 0
	IS_ROTATING = TYPE_INT
	IS_MOVING = TYPE_VECTOR3
}
var physics_state = IS_STILL

var original_angle = rotation.y
var goal_angle

var original_position = translation
var goal_position


############################## FUNCTION NATIVE ##############################


func _ready():
	pass


func _physics_process(delta):
	match physics_state:
		
		IS_ROTATING:
			rotation_degrees.y = move_toward(rotation_degrees.y, goal_angle, delta * rotation_speed)
			if rotation_degrees.y == goal_angle:
				physics_state = IS_STILL
				emit_signal("movement_end_signal", label)
		
		IS_MOVING:
			# translate((goal_position - translation).ceil(1.0) * delta * movement_speed)
			# translation = move_toward(translation, goal_position, delta * movement_speed)
			translation.x = move_toward(translation.x, goal_position.x, delta * movement_speed)
			translation.y = move_toward(translation.y, goal_position.y, delta * movement_speed)
			translation.z = move_toward(translation.z, goal_position.z, delta * movement_speed)
			if translation == goal_position:
				physics_state = IS_STILL
				emit_signal("movement_end_signal", label)


############################## .?. ##############################


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
	
	var instruction_type = typeof(instruction[0])
	if not [TYPE_INT, TYPE_VECTOR3].has(instruction_type):
		Log.error("La liste contient un type non gere: ", instruction_type)
		get_tree().quit()
	
	physics_state = instruction_type  # attribue l'état physique de la pièce selon le type
	match physics_state:
		IS_ROTATING:
			goal_angle = original_angle + instruction[0]\
			if rotation_degrees.y == original_angle else original_angle
		IS_MOVING:
			goal_position = original_position + instruction[0]\
			if translation == original_position else original_position


############################## SIGNALS RECEIVER ##############################
func _signal_handler(commands_dict):
	Log.info("received signal", commands_dict)
	
	if physics_state != IS_STILL: return
	
	if not commands_dict.has(self.label): return
	var command = commands_dict[self.label]
	
	if not instructions.has(command):
		Log.error("Pas d'instruction avec ce nom: ", command)
		return

	_action(command)







