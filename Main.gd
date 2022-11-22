extends Spatial

const CUBE_SIZE = 1

onready var cubes = $Cubes
onready var cube_src = load("res://Cube.tscn")
var cubes_object = []

# tableau par etage [y][x][z] (swap x et z ?)
const level = [
	[
		[Cube.FLOOR, Cube.FLOOR, Cube.FLOOR, Cube.FLOOR, Cube.FLOOR],
		[Cube.FLOOR, Cube.FLOOR, Cube.FLOOR, Cube.FLOOR, Cube.FLOOR],
		[Cube.FLOOR, Cube.FLOOR, Cube.FLOOR, Cube.FLOOR, Cube.FLOOR],
		[Cube.FLOOR, Cube.FLOOR, Cube.FLOOR, Cube.FLOOR, Cube.FLOOR],
		[Cube.FLOOR, Cube.FLOOR, Cube.FLOOR, Cube.FLOOR, Cube.FLOOR],
	],
	[
		[Cube.WALL,Cube.WALL,Cube.WALL,Cube.WALL,Cube.WALL],
		[Cube.NONE,Cube.NONE,Cube.NONE,Cube.NONE,Cube.NONE],
		[Cube.NONE,Cube.NONE,Cube.NONE,Cube.NONE,Cube.NONE],
		[Cube.NONE,Cube.NONE,Cube.NONE,Cube.NONE,Cube.NONE],
		[Cube.NONE,Cube.NONE,Cube.NONE,Cube.NONE,Cube.NONE],
	],
	[
		[Cube.WALL,Cube.WALL,Cube.WALL,Cube.WALL,Cube.WALL],
	]
]

func _ready():
	$Perpective.current = true
	$Orthogonal.current = false
	var map = []
	for y in len(level):
		# Reste a definir quel est le plus clair entre z et x
		for z in len(level[y]):
			for x in len(level[y][z]):
				var cube_type = level[y][z][x]
				if cube_type != 0:
					var cube = cube_src.instance()
					cube.init(Vector3(x, y, z), cube_type)
					map.push_back(cube)
#					map.push_back(Cube.new(Vector3(x, y, z), cube_type))

	populate_cubes(map)

func _input(event):
	if event.is_action_pressed("ui_down"):
		print("down")
		if $Perpective.current:
			$Orthogonal.current = true
		else:
			$Perpective.current = true

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
