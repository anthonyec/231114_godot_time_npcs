extends PlayerState

func enter(_params: Dictionary) -> void:
	var resource = load("res://dialogue/test.dialogue")
	#var _dialogue_line = await DialogueManager.get_next_dialogue_line(resource)
	
	Game.instance.temp_balloaon.start(resource, "this_is_a_node_title")
	
	await DialogueManager.dialogue_ended
	state_machine.transition_to_previous_state()
	
	