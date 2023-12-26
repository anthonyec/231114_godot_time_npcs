extends PlayerState

var target: Vector3

func enter(params: Dictionary) -> void:
	var dialogue_name = params.get("dialogue")
	assert(dialogue_name)
	
	var dialogue = Dialogue.instance
	Dialogue.instance.start(dialogue_name)
	
	var world = World.instance
	var character = Dialogue.instance.line.character
	var npc = world.find_npc_or_null(character)
	
	if npc:
		target = npc.global_position
	
	await DialogueManager.dialogue_ended
	state_machine.transition_to_previous_state()

func update(delta: float) -> void:
	player.face_towards(target, 5, delta)
	
