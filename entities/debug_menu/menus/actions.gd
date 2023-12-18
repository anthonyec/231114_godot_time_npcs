extends DebugMenuEntry

func get_items() -> Array[Dictionary]:
	return [
		{
			"label": "Reset Player and NPC states",
			"action": reset_player_and_npc_states
		},
	]

func reset_player_and_npc_states() -> void:
	var player = World.instance.get_player_or_null()
	if not player: return
	
	# TODO: Why does state_machine type here not auto complete?
	player.state_machine.transition_to("Move")
	
	var npcs = World.instance.get_npcs()
	for npc in npcs: npc.state_machine.transition_to("Move")
