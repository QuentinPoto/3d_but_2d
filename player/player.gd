extends KinematicBody
class_name Player

signal player_action

export var speed: float = 5
var _is_player_down: bool
var _velocity: Vector3

func _input(event):
	if event.is_action_pressed("on_action"):
		emit_signal("player_action", translation)

func _physics_process(delta):
	if not SwapLogic.is_swapping:
		_player_movement()
		_is_player_down = false
	else:
		_player_swapper()

############ PLAYER MOVEMENT #############
func _player_movement():
	var direction = Vector3.ZERO

	if Input.is_action_pressed("ui_right"):
		direction += Vector3(1, 0, 1)
	if Input.is_action_pressed("ui_left"):
		direction -= Vector3(1, 0, 1)
	if Input.is_action_pressed("ui_down"):
		direction += Vector3(-1, 0, 1) if not SwapLogic.is_player_down else Vector3(1, 0, -1)
	if Input.is_action_pressed("ui_up"):
		direction += Vector3(1, 0, -1) if not SwapLogic.is_player_down else Vector3(-1, 0, 1)

	if not $RayCasts/Right.is_colliding():
		direction -= Vector3(1, 0, 1)
	if not $RayCasts/Left.is_colliding():
		direction += Vector3(1, 0, 1)
	if not $RayCasts/Down.is_colliding():
		direction -= Vector3(-1, 0, 1) if not SwapLogic.is_player_down else Vector3(1, 0, -1)
	if not $RayCasts/Up.is_colliding():
		direction -= Vector3(1, 0, -1) if not SwapLogic.is_player_down else Vector3(-1, 0, 1)

	direction = direction.normalized() # permet d'eviter que ca aie 2x plus vite en diagonale

	## TODO ameliorer ca : 
	## Il prend la distance entre le raycast de gauche et le point de collision de 
	## ce dernier et descend en y en fonction de cette distance
	## ca marche en descante mais pas ouf en montee...
	direction.y = 0
	var distance_from_floor = 0
	if $RayCasts/Left.is_colliding():
		var origin = $RayCasts/Left.global_transform.origin
		var collision_point = $RayCasts/Left.get_collision_point()
		distance_from_floor = origin.distance_to(collision_point)
		if (distance_from_floor > 0.15):
			direction.y = -distance_from_floor if not SwapLogic.is_player_down else distance_from_floor
	_velocity = direction * speed
	# La fonction move_and_slide agit directement sur le KinematicBody (method de cette class)
	# Ce qui explique qu'on ne lui donne pas la translation du player en parametre
	_velocity = move_and_slide(_velocity, Vector3.UP)

##########	PLAYER SWAPPER	##########
const swap_begin: int = 45
const swap_end: int = 55
func _player_swapper():
	# Si on est pendant le swap
	if swap_begin < SwapLogic.swapping_progress and SwapLogic.swapping_progress < swap_end:
		_swap_player(true)
	
	# Si on arrive a la fin du swap, on check que le joueur est dans le bon sens !
	if SwapLogic.swapping_progress > swap_end and not _is_player_down:
		_swap_player(false)

func _swap_player(random: bool):
	# - Engine.get_frames_drawn -> nombre de frame jusqua la (augmente infiniment)
	# - Avec le modulo 10, la condition va etre vrai un fois sur N
	# -> en gros ca va faire l'effet "blinky" de la teleportation, mais on
	# 		pourrait tres bien faire juste en une fois
	if random and Engine.get_frames_drawn() % 10 == 0: 
		return
	
	var block_size = 2 # TODO const dans un fichier global ?
	
	# Rotation du joueur
	rotation_degrees.z = 0 if SwapLogic.is_player_down else 180
	rotation_degrees.y = 0 if SwapLogic.is_player_down else 90
	
	# Deplacement de l'autre cote
	translation.y = translation.y + block_size if SwapLogic.is_player_down else translation.y - block_size
	
	# Booleans
	_is_player_down = !_is_player_down
	SwapLogic.is_player_down = !SwapLogic.is_player_down

########### PLAYER FX (BLINKING)
"""
 -> effet de clignotement. Vu que le swap player creer le meme effet, pas besoin de mettre les deux...
func blincking():
	var blincking_speed: int = round(2 * abs(SwapLogic.swapping_progress - 50) / 10)
	if blincking_speed == 0:
		return
	blincking_speed = 1 if blincking_speed == 0 else blincking_speed
	var min_opacity = 0.0
	if SwapLogic.is_swapping:
		self.modulate.a = min_opacity if Engine.get_frames_drawn() % blincking_speed == 0 else 1.0
	else:
		self.modulate.a = 1.0
"""

func _on_Player_player_action(_v): pass # used to silent a warning
