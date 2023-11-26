class_name NPCState
extends State

var npc: NPC

func awake() -> void:
	npc = owner as NPC
	assert(npc != null)
