extends Camera
"""


# Logique de swap de la cam (ancien)
# Le swap actuel est dans Main.gd (le script de scene)



# TODO trouver un moyen plus dynamique de faire ca
var is_down: bool = true

# Start
var y_pos_start: float = translation.y
var x_rot_start: float = rotation_degrees.x
var z_rot_start: float = rotation_degrees.z

# Dist
var y_pos_dist: float = abs(translation.y * 2)
var x_rot_dist: float = abs(rotation_degrees.x * 2)
var z_rot_dist: float = 180


var calculed: bool = false
func swapper_calcul():
	# keep from relauching the calcul
	calculed = true
	is_down = !is_down
	y_pos_start = translation.y
	x_rot_start = rotation_degrees.x
	z_rot_start = rotation_degrees.z


func _physics_process(_delta):
	if SwapLogic.is_swapping:
		if not calculed:
			swapper_calcul()
		# TODO opty tout ca...
		if is_down:	
			translation.y = y_pos_start + y_pos_dist * SwapLogic.swapping_p / 100
			rotation_degrees.x = x_rot_start - x_rot_dist * SwapLogic.swapping_p / 100
			#rotation_degrees.z = z_rot_start + z_rot_dist * SwapLogic.swapping_p / 100
		else:
			translation.y = y_pos_start - y_pos_dist * SwapLogic.swapping_p / 100
			rotation_degrees.x = x_rot_start + x_rot_dist * SwapLogic.swapping_p / 100
			#rotation_degrees.z = z_rot_start - z_rot_dist * SwapLogic.swapping_p / 100
	else:
		calculed = false

	pass
"""

"""
# Code pour faire rotation
extends KinematicBody

#############################
var RotateSpeed = 2
var Radius = 1
var _centre
var _angle = 0
func _ready():
	set_process(true)
	_centre = Vector2(translation.x, translation.z)
func _process(delta): 
	_angle += RotateSpeed * delta;
	var offset = Vector2(sin(_angle), cos(_angle)) * Radius;
	var pos: Vector2 = _centre + offset
	translation = Vector3(pos.x, 1, pos.y)
############################
"""
