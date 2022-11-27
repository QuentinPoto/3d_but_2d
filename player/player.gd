extends KinematicBody
class_name Player

signal player_action

export var speed: float = 3
var player_swapped: bool # Make private ??
var _velocity: Vector3

# TODO pour que les collision fonctionnent avec la gridmap, il faut ajouter une shape a chaque cube dans la mesh library

func _input(event):
	if event.is_action_pressed("on_action"):
		emit_signal("player_action", translation)

func _physics_process(delta):
	if not SwapLogic.is_swapping:
		_player_movement()
		player_swapped = false
	else:
		_player_swapper()

func _on_floor(new_pos: Vector3) -> bool:
	var ray = $RayCast
	print(ray.is_colliding())
	return ray.is_colliding()
	"""
	var _floor: GridMap = get_node("../GridMap")
	var floor_pos = _floor.world_to_map(new_pos.round())
	var floor_tile = _floor.get_cell_item(floor_pos.x, floor_pos.y, floor_pos.z)
	print("new_pos ", new_pos,"floor_pos ", floor_pos, "floor_t ", floor_tile)
	return floor_tile != -1
	"""

############ PLAYER MOVEMENT #############
func _player_movement():
	_on_floor(translation)
	var direction = Vector3.ZERO
	if Input.is_action_pressed("ui_right"):
		direction += Vector3(1, 0, 1)
	if Input.is_action_pressed("ui_left"):
		direction -= Vector3(1, 0, 1)
	if not SwapLogic.is_player_down:
		if Input.is_action_pressed("ui_down"):
			direction += Vector3(-1, 0, 1)
		if Input.is_action_pressed("ui_up"):
			direction += Vector3(1, 0, -1)
	else:
		if Input.is_action_pressed("ui_down"):
			direction -= Vector3(-1, 0, 1)
		if Input.is_action_pressed("ui_up"):
			direction -= Vector3(1, 0, -1)
	direction = direction.normalized() # permet d'eviter que ca aie 2x plus vite en diagonale
	_velocity.x = direction.x * speed
	_velocity.z = direction.z * speed
	_velocity.y = 0 # TODO a enlever en cas d'echelle
	#if _on_floor(translation + _velocity * Vector3.UP): # TODO comment empecher de tomber ??
	_velocity = move_and_slide(_velocity, Vector3.UP)

##########	PLAYER SWAPPER	##########
const swap_begin: int = 45
const swap_end: int = 55

func _player_swapper():
	if swap_begin < SwapLogic.swapping_p and SwapLogic.swapping_p < swap_end:# and not player_swapped:
		_swap_player(true)
	if SwapLogic.swapping_p > swap_end and not player_swapped:
		_swap_player(false)

func _swap_player(random: bool):
	# Engine.get_frames_drawn -> nombre de frame jusqua la (augmente infiniment)
	# Avec le modulo 10, la condition va etre vrai un fois sur x
	if random and Engine.get_frames_drawn() % 10 == 0:
		return
	#translation.y = -(translation.y)
	var block_size = 2
	translation.y = translation.y + block_size if SwapLogic.is_player_down else translation.y - block_size
	$Sprite.rotation_degrees.z = 0 if $Sprite.rotation_degrees.z == 180 else 180
	player_swapped = !player_swapped
	SwapLogic.is_player_down = !SwapLogic.is_player_down


########### PLAYER FX (BLINKING)
"""
 -> effet de clignotement. Vu que le swap player creer le meme effet, pas besoin de mettre les deux...
func blincking():
	var blincking_speed: int = round(2 * abs(SwapLogic.swapping_p - 50) / 10)
	if blincking_speed == 0:
		return
	blincking_speed = 1 if blincking_speed == 0 else blincking_speed
	var min_opacity = 0.0
	if SwapLogic.is_swapping:
		self.modulate.a = min_opacity if Engine.get_frames_drawn() % blincking_speed == 0 else 1.0
	else:
		self.modulate.a = 1.0
"""




func _on_Player_player_action(_v): pass # used to silent the warning...
