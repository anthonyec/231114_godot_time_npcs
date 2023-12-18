extends DebugMenuEntry

func get_items() -> Array[Dictionary]:
	var items: Array[Dictionary]

	var flags = Flags.new()
	var script = flags.get_script() as Script
	var code = script.source_code
	
	var regex = RegEx.new()
	regex.compile("const (.+)")
	
	for result in regex.search_all(code):
		var flag_name = result.get_string().replace("const ", "").split(" = ")[0].strip_edges()
		
		items.append({
			"label": flag_name,
			"action": func(): Flags.toggle(flag_name),
			"is_active": Flags.is_enabled(flag_name)
		})

	return items
