extends Node

const swapping_speed: int = 60
var is_swapping: bool = false
var swapping_p: float = 0 # pourcentage de ou on en est dans le swapping #TODO rename

func on_reverse_map():
	# Appeler depuit ou on veut pour lancer le swap
	# Empeche the player to relauch the action during a movement
	if is_swapping:
		return
	is_swapping = true

func _physics_process(delta):
	if swapping_p == 100:
		swapping_p = 0
		is_swapping = false
	if is_swapping:
		swapping_p = move_toward(swapping_p, 100, delta * swapping_speed)


######### UTILS ########
# deux distance et la vitesse SwapLogic
static func speed_ratio(a: float, b: float, speed: float) -> float:
	if a < b:
		return (a / b) * speed
	else:
		return (b / a) * speed


# TODO aileurs ? -> 
var is_player_down: bool = false # if the player is in the upside down (not for animation !!!! -> is changed to the begining of the animation)
