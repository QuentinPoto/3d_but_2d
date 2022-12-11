extends GridMap

signal rotation_end

# TODO truc dynamic ou on peut avoir plus de rotation
export var rotation_a: int = 0
export var rotation_b: int = 90
export var rotation_speed: int = 5
export var is_moving: bool = false # public si on veut l'activer au debut du niveau
export var interaction_tags: Array

var _rotation_goal: float

func _rotate():
	is_moving = true
	_rotation_goal = rotation_b if rotation_degrees.y == rotation_a else rotation_a

func _physics_process(delta):
	if is_moving:
		rotation_degrees.y = move_toward(rotation_degrees.y, _rotation_goal, delta * rotation_speed)
		is_moving = not rotation_degrees.y == _rotation_goal
		if not is_moving:
			emit_signal("rotation_end")

func _on_Lever_lever_signal(_is_flipped: bool, sent_interaction_tag: Array):
	print(_is_flipped)
	if \
	not is_moving \
	and is_matching_interaction(sent_interaction_tag, interaction_tags):
		_rotate()

func _on_pplaque_state_change(pressed: bool, sent_interaction_tag: Array):
	if \
	not is_moving \
	and is_matching_interaction(sent_interaction_tag, interaction_tags) \
	and pressed:
		_rotate()

# TODO rendre public !!!
func is_matching_interaction(emiter_interaction_tags: Array, reciver_interaction_tags: Array):
	for interaction_tag in emiter_interaction_tags:
		if reciver_interaction_tags.has(interaction_tag):
			return true
	return false
