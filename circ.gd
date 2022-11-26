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
