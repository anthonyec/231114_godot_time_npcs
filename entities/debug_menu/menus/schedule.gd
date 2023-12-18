extends DebugMenuEntry

func get_items() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	items.append({
		"label": "Time: " + World.instance.get_display_time() + " Day " + str(World.instance.day)
	})
	
	items.append({
		"label": "World clock ticking",
		"action": toggle_world_clock_ticking,
		"is_active": World.instance.ticking
	})
	
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
	
func draw(control: Control) -> void:
	var size = Vector2(control.size.x, 100)
	
	control.draw_rect(Rect2(0, control.size.y - size.y, size.x, size.y), Color(0, 0, 0, 0.2))
	
	for event in NPCSchedule.instance.schedule:
		var start_time = event.get("start_time", 0)
		var end_time = event.get("end_time", 0)
		var start_timestamp = NPCSchedule.get_timestamp(start_time[0], start_time[1])
		var end_timestamp = NPCSchedule.get_timestamp(end_time[0], end_time[1])
		

func toggle_world_clock_ticking() -> void:
	World.instance.ticking = !World.instance.ticking
