extends Spatial # extend depuis GridMap ?
class_name Receiver

############################## SIGNAL & VAR ##############################
signal movement_end_signal

export var label: String
export var instructions: Dictionary = {}  # { "InstructionName": [3] }

export var has_child: bool = false # important ! permet de check dans ses enfants pour d'autre receiver

export var movement_speed: int = 2
export var rotation_speed: int = 100

enum {
	IS_STILL = 0
	IS_ROTATING = TYPE_INT
	IS_MOVING = TYPE_VECTOR3
}
var physics_state = IS_STILL

var original_angle: float
var goal_angle: float
var original_position: Vector3
var goal_position: Vector3

var is_ascending: bool = true # en gros c'est la direction dans laquel il va en suivant la liste
var instruction_index: int = 0

############################## FUNCTION NATIVE ##############################


func _ready():
	original_position = translation
	original_angle = rotation_degrees.y

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

func _set_goal(instruction: Array):
	original_position = translation
	original_angle = rotation_degrees.y
	Log.info("original pos and rot: ", original_position, original_angle)
	var this_instruction = instruction[instruction_index] if is_ascending else - instruction[instruction_index]
	if physics_state == IS_MOVING:
		goal_position = original_position + this_instruction
	elif physics_state == IS_ROTATING:
		goal_angle = original_angle + this_instruction
	if is_ascending:
		instruction_index += 1
		if instruction_index == len(instruction):
			is_ascending = false
			instruction_index -= 1
	elif not is_ascending:
		instruction_index -= 1
		if instruction_index == -1:
			is_ascending = true
			instruction_index = 0

func _action(instructionName: String): ## OVERRIDE
	Log.debug("there is a matching instruction: ", typeof(instructions[instructionName]), instructions[instructionName])
	var instruction = instructions[instructionName]
	if typeof(instruction) != TYPE_ARRAY:
		Log.crash("Le type d'instruction ne fonctionne pas ! (n'est pas une liste...)")
	if len(instruction) == 0:
		Log.crash("ERROR, la liste est vide !")
	
	var instruction_type = typeof(instruction[0])
	if not [TYPE_INT, TYPE_VECTOR3].has(instruction_type):
		Log.crash("La liste contient un type non gere: ", instruction_type)

	physics_state = instruction_type  # attribue l'état physique de la pièce selon le type
	_set_goal(instruction)



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







