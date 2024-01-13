extends NPCState

func enter(params: Dictionary) -> void:
	var target_node = params.get("node")
	
	# TODO: Fix this does not already look at target or stops halfway.
	if target_node:
		npc.control_state_machine.transition_to("LookAt", { "node": target_node })
	
	# TOOD: Await dialogue ended here.
	state_machine.transition_to_previous_state()
