class_name Cube
extends MeshInstance

enum {
	NONE
	FLOOR
	WALL
}

var pos: Vector3	# Position dans la map
var tex: int		# Enum de la texture

func _set_tex():
	match self.tex:
		FLOOR:
			self.mesh = load("res://texture/floor_cubemesh.tres")
			print("floor")
		WALL:
			self.mesh = load("res://texture/wall_cubemesh.tres")
			print("wall")
			
func init(pos: Vector3, tex: int):
	self.pos = pos
	self.tex = tex
	_set_tex()
	
	
func _ready():
	#set_surface_material(1, load("res://texture/wall.tres"))
	pass
