extends Sprite3D
class_name Player

signal player_action

func _ready():
	modulate.a = 1
	opacity = 1


func _input(event):
	"""
	if event.is_action_pressed("ui_up"):
		translation.x += 1
	elif event.is_action_pressed("ui_down"):
		translation.x -= 1
	elif event.is_action_pressed("ui_left"):
		translation.z -= 1
	elif event.is_action_pressed("ui_right"):
		translation.z += 1
	"""
	if event.is_action_pressed("on_action"):
		emit_signal("player_action", translation)


var speed_v: float = 5
var speed_h: float = speed_v * 0.5 # racine 3 sur 3

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		translation.x += speed_v * delta
		translation.z -= speed_v * delta
	if Input.is_action_pressed("ui_down"):
		translation.x -= speed_v * delta
		translation.z += speed_v * delta
	if Input.is_action_pressed("ui_left"):
		translation.x -= speed_h * delta
		translation.z -= speed_h * delta
	if Input.is_action_pressed("ui_right"):
		translation.x += speed_h * delta
		translation.z += speed_h * delta

var player_swapped: bool

func swap_player(random: bool):
	# Engine.get_frames_drawn -> nombre de frame jusqua la (augmente infiniment)
	# Avec le modulo 10, la condition va etre vrai un fois sur x
	if random and Engine.get_frames_drawn() % 10 == 0:
		return
	translation.y = -(translation.y)
	rotation_degrees.x = -(rotation_degrees.x)
	rotation_degrees.z = 0 if rotation_degrees.z == 180 else 180
	player_swapped = !player_swapped


const swap_begin: int = 45
const swap_end: int = 55
func _physics_process(_delta):
	if not SwapLogic.is_swapping:
		player_swapped = false
		return
	if swap_begin < SwapLogic.swapping_p and SwapLogic.swapping_p < swap_end:# and not player_swapped:
		swap_player(true)
	if SwapLogic.swapping_p > swap_end and not player_swapped:
		swap_player(false)


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
