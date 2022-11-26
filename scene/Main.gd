extends Spatial

const CUBE_SIZE = 1

onready var cubes = $Cubes
onready var cube_src = load("res://map_blocks/Cube.tscn")
var cubes_object = []


var cam_swapped = false


func _process(delta):
	pass
	if SwapLogic.is_swapping and not cam_swapped:
		$CameraDown.current = !$CameraDown.current
		cam_swapped = true
	if not SwapLogic.is_swapping:
		cam_swapped = false

"""

# tableau par etage [y][x][z] (swap x et z ?)
const level = [
	[
		[Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH],
		[Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH],
		[Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH],
		[Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH],
		[Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH],
		[Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH],
		[Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH],
		[Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH],
		[Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH],
		[Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH],
		[Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH],
		[Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH],
		[Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH],
		[Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH, Cube.EARTH],
	],
	[
		[Cube.STONE,Cube.STONE,Cube.STONE,Cube.STONE,Cube.STONE],
	],
	[
		[Cube.STONE,Cube.STONE,Cube.STONE,Cube.STONE,Cube.STONE],
	]
]

func _ready():
	if ($Perpective != null):
		$Perpective.current = true
		$Orthogonal.current = false
	var map = []
	return
	for y in len(level):
		# Reste a definir quel est le plus clair entre z et x
		for z in len(level[y]):
			for x in len(level[y][z]):
				var cube_type = level[y][z][x]
				if cube_type != 0:
					var cube = cube_src.instance()
					cube.init(Vector3(x, y, z), cube_type)
					map.push_back(cube) 
	populate_cubes(map)

func populate_cubes(map):
	if len(map) == 0:
		print("map vide")
		return
	#if typeof(map[0] != Cube):
	#	print("pas de type Cube...")
	#	return
	for cube in map:
		add_child(cube)
		cube.translation = cube.pos * CUBE_SIZE * 2
"""
