extends Node

enum { # FOR THE LADDERS, THE SIDE WHERE THE PLAYER IS TO GO UP
	LEFT
	RIGHT
	UP
	DOWN
}

func raycast_collision_distance(raycast: RayCast) -> float:
	if not raycast.is_colliding():
		return NAN
	var origin: float = raycast.get_collision_point().y
	return raycast.global_transform.origin.y - origin

