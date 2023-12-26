extends NPCState

func enter(_params: Dictionary) -> void:
	await DialogueManager.dialogue_ended
	state_machine.transition_to_previous_state()
