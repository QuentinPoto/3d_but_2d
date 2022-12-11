extends KinematicBody

export var speed: float = 2

var _is_player_down: bool = false
var _ladder_contact_front: bool = false
var _ladder_contact_top: bool = false
var _ladder_direction

func _physics_process(delta):
	if not SwapLogic.is_swapping:
		_player_movement()
		_is_player_down = false
	else:
		_player_swapper()

############ PLAYER MOVEMENT #############

func _player_movement() -> void:
	var direction
	if _ladder_contact_front and _ladder_front_movement():
		return
	direction = _normal_movement()
	if not _ladder_contact_top:
		_border_check(direction)

func _normal_movement() -> Vector3:
	var orientation = Vector2.ZERO
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction += Vector3(1, 0, 1)
		orientation += Vector2(1, 0)
	if Input.is_action_pressed("ui_left"):
		direction += Vector3(-1, 0, -1)
		orientation += Vector2(-1, 0)
	if Input.is_action_pressed("ui_up"):
		direction += Vector3(1, 0, -1)
		orientation += Vector2(0, 1)
	if Input.is_action_pressed("ui_down"):
		direction += Vector3(-1, 0, 1)
		orientation += Vector2(0, -1)
	
	direction = direction.normalized()
	
	$AnimationTree.set("parameters/Movement/blend_position", orientation)
	
	if SwapLogic.is_player_down:
		var _temp = direction.x
		direction.x = direction.z
		direction.z = _temp
	
	direction = direction.normalized()
	direction.y = 1 if SwapLogic.is_player_down else -1 # gravity TODO ameliorer
	move_and_slide(direction * speed)
	return direction

func _border_check(direction: Vector3) -> void: # TODO : il double la vitesse !!!
	# swap la direction pour annuler le movement si on est au bord
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

	# La fonction move_and_slide agit directement sur le KinematicBody (method de cette class)
	# Ce qui explique qu'on ne lui donne pas la translation du player en parametre
	move_and_slide(direction * speed)

func _ladder_front_movement() -> bool: # return true s'il a bouge, false si le normal_movement doit etre appele
	if _ladder_contact_top:
		return false

	# set la direction voulue (input)
	var rl_direction: int = -1
	if Input.is_action_pressed("ui_left"):
		rl_direction = Global.LEFT
	elif Input.is_action_pressed("ui_right"):
		rl_direction = Global.RIGHT

	# Si on touche le sol
	# et qu'on veut aller vers le bas
	# ou qu'on veut aller a l'opposer de l'echelle
	# 	-> on demande un _normal_movement
	if _is_on_floor_step() \
	and (Input.is_action_pressed("ui_down") \
	or (rl_direction != -1 and rl_direction != _ladder_direction)):
		return false

	# set la direction
	var direction = Vector3.ZERO
	if Input.is_action_pressed("ui_up"):
		direction.y = 1
	elif Input.is_action_pressed("ui_down"):
		direction.y = -1
	if rl_direction != -1:
		direction.y = 1 if rl_direction == _ladder_direction else -1

	# TODO 
	if SwapLogic.is_player_down:
		direction.y = -direction.y


	move_and_slide(direction * speed)
	return true

func _is_on_floor_step() -> bool: # renvoie true si le joueur est a la hauteur y de toucher le sol 
	var tresh_hold: float = 0.25 # CONST
	var distance_from_floor: float = Global.raycast_collision_distance($RayCasts/Middle)
	return tresh_hold >= distance_from_floor or distance_from_floor <= -tresh_hold




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

func _on_ladder1_ladder_contact_change(is_contact_front, is_contact_top, ladder_direction):
	_ladder_contact_front = is_contact_front
	_ladder_contact_top = is_contact_top
	_ladder_direction = ladder_direction
	print ("ladder front: ", _ladder_contact_front, ", ladder top: ", _ladder_contact_top)
