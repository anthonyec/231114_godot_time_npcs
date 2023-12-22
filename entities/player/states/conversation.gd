extends PlayerState

func enter(_params: Dictionary) -> void:
	var dialogue = Dialogue.instance
	dialogue.start("test")
	
	await DialogueManager.dialogue_ended
	state_machine.transition_to_previous_state()
	
	
