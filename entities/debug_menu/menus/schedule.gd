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
	
	var world = World.instance
	var npc_schedule = NPCSchedule.instance
	
	for event: NPCSchedule.Event in npc_schedule.events:
		var is_active = world.get_military_time() >= event.start_time and world.get_military_time() < event.end_time
		
		items.append({
			"label": event.get_start_display_time() + " - " + event.get_end_display_time() + ": " + event.npc + " at " + event.location + " in " + event.level,
			"action": func(): World.instance.hour = event.get_start_hour(); World.instance.minute = event.get_start_minute(),
			"is_active": is_active
		})
	
	return items

func toggle_world_clock_ticking() -> void:
	World.instance.ticking = !World.instance.ticking
