extends DebugMenuEntry

func get_items() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	for event in NPCSchedule.instance.schedule:
		var npc = event.get("npc", "")
		var start_time = event.get("start_time", [0, 0])
		var location = event.get("location", "")
		var level = event.get("level", "")
		
		items.append({
			"label": str(start_time[0]) + ":" + str(start_time[1]) + "  " + npc + " " + level + " " + location,
			"action": func(): World.instance.hour = start_time[0]; World.instance.minute = start_time[1]
		})
	
	return items
