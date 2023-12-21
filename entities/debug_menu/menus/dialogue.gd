extends DebugMenuEntry

func get_items() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	var dialogue = Dialogue.instance
	if not dialogue: return items
	
	var directory = DirAccess.open("res://dialogue")
	if not directory: return items
	
	directory.list_dir_begin()
	var filename = directory.get_next()
	
	while filename:
		if filename.get_extension() == "dialogue":
			items.append({
				"label": filename.get_basename(),
				"action": func(): dialogue.start(filename.get_basename())
			})
		
		filename = directory.get_next()
	
	return items
