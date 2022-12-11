extends Spatial

signal ladder_contact_change

var _have_contact_front: bool = false
var _have_contact_top: bool = false
var _direction

func _ready():
	if rotation_degrees.z == 0:
		_direction = Global.LEFT if rotation_degrees == Vector3.ZERO else Global.RIGHT
	else:
		_direction = Global.LEFT if rotation_degrees.y == 90 else Global.RIGHT

func _process(delta):
	var front_contact: bool = $RayCasts.is_player_contact()
	var top_contact: bool = $RayCastsTop.is_player_contact()
	if front_contact != _have_contact_front or top_contact != _have_contact_top:
		_have_contact_front = front_contact
		_have_contact_top = top_contact
		emit_signal("ladder_contact_change", _have_contact_front, _have_contact_top, _direction)
