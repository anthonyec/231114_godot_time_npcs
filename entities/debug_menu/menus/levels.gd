extends DebugMenuEntry

func get_items() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	var game = Game.instance
	if not game: return items
	
	var directory = DirAccess.open("res://levels")
	if not directory: return items
	
	directory.list_dir_begin()
	var filename = directory.get_next()
	
	while filename:
		items.append({
			"label": filename,
			"action": func(): game.load_level(filename)
		})
		
		filename = directory.get_next()
	
	return items
