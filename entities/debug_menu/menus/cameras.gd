extends DebugMenuEntry

func get_items() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	for camera in World.instance.get_cameras():
		items.append({
			"label": camera.name,
			"action": camera.make_current,
			"is_active": camera.current
		})

	return items
