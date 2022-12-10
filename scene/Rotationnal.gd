extends GridMap

# TODO truc dynamic ou on peut avoir plus de rotation
export var rotation_a: int = 0
export var rotation_b: int = 90
export var rotation_speed: int = 5
export var is_moving: bool = false # public si on veut l'activer au debut du niveau

var _rotation_goal: float

func _ready(): # TODO remplacer par le signal
	_rotate()

func _rotate():
	is_moving = true
	_rotation_goal = rotation_b if rotation_degrees.y == rotation_a else rotation_a

func _physics_process(delta):
	if is_moving:
		rotation_degrees.y = move_toward(rotation_degrees.y, _rotation_goal, delta * rotation_speed)
		is_moving = not rotation_degrees.y == _rotation_goal
