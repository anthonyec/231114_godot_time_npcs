@tool
extends DialogicIndexer

func _get_events() -> Array:
	return list_dir()
