extends KinematicBody
class_name Player

signal player_action

export var speed: float = 2
var _is_player_down: bool

func _input(event):
	if event.is_action_pressed("on_action"):
		print("action ", translation)
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
		direction += Vector3(-1, 0, -1)
	if Input.is_action_pressed("ui_up"):
		direction += Vector3(1, 0, -1)
	if Input.is_action_pressed("ui_down"):
		direction += Vector3(-1, 0, 1)
	
	if SwapLogic.is_player_down:
		var _temp = direction.x
		direction.x = direction.z
		direction.z = _temp
	
	direction = direction.normalized()
	move_and_slide(direction * speed)
	
	if SwapLogic.is_player_down:
		var _temp = direction.x
		direction.x = direction.z
		direction.z = _temp
	
	if not $RayCasts/DownRight.is_colliding():
		if not direction.z: direction.z = 1
		direction.z = -direction.z
	if not $RayCasts/DownLeft.is_colliding():
		if not direction.x: direction.x = -1
		direction.x = -direction.x
	if not $RayCasts/UpRight.is_colliding():
		if not direction.x: direction.x = 1
		direction.x = -direction.x
	if not $RayCasts/UpLeft.is_colliding():
		if not direction.z: direction.z = -1
		direction.z = -direction.z
	
	if SwapLogic.is_player_down:
		var _temp = direction.x
		direction.x = direction.z
		direction.z = _temp
	"""
	## TODO ameliorer ca :
	if $RayCasts/Middle.is_colliding():
		var origin = $RayCasts/Middle.global_transform.origin
		var collision = $RayCasts/Middle.get_collision_point()
		direction.y = (collision - origin).y
	"""
	direction.y = 1 if SwapLogic.is_player_down else -1
	
	# La fonction move_and_slide agit directement sur le KinematicBody (method de cette class)
	# Ce qui explique qu'on ne lui donne pas la translation du player en parametre
	move_and_slide(direction * speed)

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
