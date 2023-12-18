extends DebugMenuEntry

func get_items() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	for marker in World.instance.get_place_markers():
		items.append({
			"label": marker.name,
			"highlight_action": _on_highlight_place_menu_item.bind(marker.name),
			"action": func():
				var player = World.instance.get_player_or_null()
				if not player: return
				
				World.instance.teleport_player(marker.global_position)
		})
		
	if items.is_empty():
		items.append({ "label": "No place markers found in level" })
	
	return items
	
func _on_highlight_place_menu_item(marker_name: String) -> void:
	var marker = World.instance.find_node_or_null(marker_name)
	if not marker: return
	
	DebugDraw.draw_cube(marker.global_position, 1, Color.BLACK)
