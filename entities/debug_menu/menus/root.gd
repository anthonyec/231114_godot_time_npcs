extends DebugMenuEntry

func get_items() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	var directory = DirAccess.open("res://entities/debug_menu/menus")
	if not directory: return items
	
	directory.list_dir_begin()
	var filename = directory.get_next()
	
	while filename:
		var menu_name = filename.get_basename()
		
		if menu_name != "root":
			items.append({
				"label": menu_name,
				"menu": menu_name
			})
		
		filename = directory.get_next()
	
	items.sort_custom(func(a: Dictionary, b: Dictionary):
		return a.get("label", "") < b.get("label", "")
	)
	
	return items
