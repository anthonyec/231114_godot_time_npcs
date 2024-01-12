@tool
extends DialogicIndexer

func _get_events() -> Array:
	return [
		this_folder.path_join('event_level.gd'),
		this_folder.path_join('event_switch_camera.gd'),
		this_folder.path_join('event_walk_to.gd'),
	]
