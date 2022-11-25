class_name Cube
extends MeshInstance

enum {
	NONE
	FLOOR
	WALL
	EARTH
	STONE
	SEA
}

var pos: Vector3	# Position dans la map
var tex: int		# Enum de la texture

func _set_tex():
	var current_path = "res://map_blocks/"
	match self.tex:
		FLOOR:
			self.mesh = load(current_path + "texture/floor_cubemesh.tres")
		WALL:
			self.mesh = load(current_path +  "texture/wall_cubemesh.tres")
		STONE:
			self.mesh = load(current_path + "texture/stone_cubemesh.tres")
		EARTH:
			self.mesh = load(current_path +  "texture/earth_cubemesh.tres")
		SEA:
			self.mesh = load(current_path +  "texture/sea_cubemesh.tres")

func init(_pos: Vector3, _tex: int):
	self.pos = _pos
	self.tex = _tex
	_set_tex()
	
const BLOCK_SIZE = 1.005
func _physics_process(_delta):
	if SwapLogic.is_swapping and SwapLogic.swapping_p < 50:
		scale /= BLOCK_SIZE
	elif SwapLogic.is_swapping and SwapLogic.swapping_p > 50:
		scale *= BLOCK_SIZE
	else:
		scale = Vector3(1, 1, 1)
		
