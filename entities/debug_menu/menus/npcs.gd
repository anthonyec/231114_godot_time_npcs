extends DebugMenuEntry

func get_items() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	for npc in World.instance.get_npcs():
		items.append({
			"label": npc.npc_name,
			"action": func(): World.instance.teleport_player(npc.global_position + npc.forward),
		})

	return items
