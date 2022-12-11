extends Spatial

export var enable_middle: bool = true
export var enable_corners: bool = true
export var enable_borders: bool = true

func _ready(): # TODO moins moche ?
	$Middle.enabled = enable_middle
	$Corner1.enabled = enable_corners
	$Corner2.enabled = enable_corners
	$Corner3.enabled = enable_corners
	$Corner4.enabled = enable_corners
	$Border1.enabled = enable_borders
	$Border2.enabled = enable_borders
	$Border3.enabled = enable_borders
	$Border4.enabled = enable_borders

func is_player_contact() -> bool:
	for ray_cast in get_children():
		if ray_cast.is_colliding():
			return true
	return false
