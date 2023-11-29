class_name LevelPortal
extends Area3D

@export var level_name: String

@onready var collision = $CollisionShape3D as CollisionShape3D

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	
func _on_body_entered(body: Node3D) -> void:
	var npc_schedule = NPCSchedule.instance
	
	if body is NPC:
		var npc = body as NPC
		
		if npc_schedule.should_npc_be_in_level(npc.npc_name, level_name):
			npc.queue_free()
		
	if body is Player:
		var player = body as Player
		print(player)
		Game.instance.load_level(level_name)

func _on_body_exited(body: Node3D) -> void:
	pass
