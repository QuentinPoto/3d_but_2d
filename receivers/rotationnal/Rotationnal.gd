extends Receiver

############################## SIGNAL & VAR ##############################

signal rotation_end

# ancienne method
export var rotation_a: int = 0
export var rotation_b: int = 90
export var rotation_speed: int = 5
var _rotation_goal: float

############################## FUNCTION NATIVE ##############################
func _physics_process(delta):
	if is_moving:
		rotation_degrees.y = move_toward(rotation_degrees.y, _rotation_goal, delta * rotation_speed)
		is_moving = not rotation_degrees.y == _rotation_goal
		if not is_moving:
			emit_signal("rotation_end")

############################## ... ##############################

# ancienne method
func _rotate():
	is_moving = true
	_rotation_goal = rotation_b if rotation_degrees.y == rotation_a else rotation_a

############################## OVERRIDEN ##############################
# Cette fonction est appelee depuis la classe mere
func _action(interactionName: String):
	# ce qui est defini dans la classe mere
	._action(interactionName) 
	
	# ce qui est propre a chaque receiver
	Log.debug("receiver._action !")

