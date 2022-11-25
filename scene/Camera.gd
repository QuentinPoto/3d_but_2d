extends Camera

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
			rotation_degrees.z = z_rot_start + z_rot_dist * SwapLogic.swapping_p / 100
		else:
			translation.y = y_pos_start - y_pos_dist * SwapLogic.swapping_p / 100
			rotation_degrees.x = x_rot_start + x_rot_dist * SwapLogic.swapping_p / 100
			rotation_degrees.z = z_rot_start - z_rot_dist * SwapLogic.swapping_p / 100
	else:
		calculed = false
