extends NPCState

func enter(_params: Dictionary) -> void:
	await DialogueManager.dialogue_ended
	state_machine.transition_to_previous_state()

func handle_message(title: String, _params: Dictionary) -> void:
	if title == "end_conversation":
		return state_machine.transition_to_previous_state()
