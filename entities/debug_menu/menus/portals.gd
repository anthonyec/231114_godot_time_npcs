extends DebugMenuEntry

func get_items() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	for portal in World.instance.get_level_portals():
		items.append({
			"label": portal.level_name,
			"action": func(): World.instance.teleport_player(portal.global_position - (portal.global_basis.z * 2)),
		})

	return items

