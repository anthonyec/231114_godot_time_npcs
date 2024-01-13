extends DebugMenuEntry

const narratives_path: String = "res://narrative/timelines"

func get_items() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	var directory = DirAccess.open("res://narrative/timelines")
	if not directory: return items
	
	directory.list_dir_begin()
	var filename = directory.get_next()
	
	while filename:
		if filename.get_extension() == "dtl":
			items.append({
				"label": filename.get_basename(),
				"action": func(): load_timeline(narratives_path.path_join(filename))
			})
		
		filename = directory.get_next()
	
	return items

func load_timeline(path: String) -> void:
	if Dialogic.current_timeline != null: return
	print("start %s" % path)
	
	Dialogic.start(path)
