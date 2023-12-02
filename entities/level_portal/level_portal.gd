class_name LevelPortal
extends Area3D

@export var level_name: String

@onready var collision = $CollisionShape3D as CollisionShape3D

var npcs: Array[NPC] = []

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	
	var world = World.instance
	if not world: return
	
	world.connect("minute_tick", remove_npcs_if_needed)
	
func remove_npcs_if_needed() -> void:
	if npcs.is_empty(): return
	
	var npc_schedule = NPCSchedule.instance
	
	for npc in npcs:
		if npc_schedule.should_npc_be_in_level(npc.npc_name, level_name):
			npc.queue_free()
	
func _on_body_entered(body: Node3D) -> void:
	if body is NPC:
		npcs.append(body as NPC)
		remove_npcs_if_needed()
	
	if body is Player:
		Game.instance.load_level(level_name)

func _on_body_exited(body: Node3D) -> void:
	var index = npcs.find(body as NPC)
	if index == -1: return
	
	npcs.remove_at(index)
