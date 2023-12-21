extends DebugMenuEntry

func get_items() -> Array[Dictionary]:
	return [
		{
			"label": "Reset Player and NPC states",
			"action": reset_player_and_npc_states
		},
		{ "label": "Set FPS 5", "action": func(): Engine.max_fps = 5 },
		{ "label": "Set FPS 12", "action": func(): Engine.max_fps = 12 },
		{ "label": "Set FPS 20", "action": func(): Engine.max_fps = 20 },
		{ "label": "Set FPS 30", "action": func(): Engine.max_fps = 30 },
		{ "label": "Set FPS 60", "action": func(): Engine.max_fps = 60 },
	]

func reset_player_and_npc_states() -> void:
	var player = World.instance.get_player_or_null()
	if not player: return
	
	# TODO: Why does state_machine type here not auto complete?
	player.state_machine.transition_to("Move")
	
	var npcs = World.instance.get_npcs()
	for npc in npcs: npc.state_machine.transition_to("Move")
