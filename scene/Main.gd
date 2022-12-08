extends Spatial

func _process(delta):
	_swap_camera()

# Gere le swap des deux camera
# TODO faire un rotation de l'une a l'autre
var cam_swapped = false
func _swap_camera():
	if SwapLogic.is_swapping and not cam_swapped:	
		$CameraDown.current = !$CameraDown.current
		cam_swapped = true
	if not SwapLogic.is_swapping:
		cam_swapped = false
