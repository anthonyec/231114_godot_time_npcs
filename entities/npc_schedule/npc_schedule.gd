class_name NPCSchedule
extends Node

# TODO: Maybe make it autoload from a folder.
@export var events: Array[NPCScheduleEvent] = []

#var characters_to_current_event: Dictionary = {}

var characters_to_events: Dictionary = {}

func _ready() -> void:
	assert(World.instance, "World node in scene required")
#	World.instance.connect("minute_tick", _on_world_minute_tick)

	for event in events:
		if not characters_to_events.has(event.npc):
			characters_to_events[event.npc] = []
		
		var character_events = characters_to_events.get(event.npc) as Array[NPCScheduleEvent]
		character_events.append(event)
	
	for character in characters_to_events:
		var events = characters_to_events[character] as Array[NPCScheduleEvent]
		
		events.sort_custom(func(a: NPCScheduleEvent, b: NPCScheduleEvent):
			var timestamp_a = a.get_timestamp()
			var timestamp_b = b.get_timestamp()
			return timestamp_a < timestamp_b
		)
		
		characters_to_events[character] = events
		
	print(characters_to_events)
	
func _on_world_minute_tick() -> void:
	var world = World.instance
	print(world.hour, ", ", world.minute)
	
	for event in events:
#		print(event.hour, ", ", event.minute)
		if event.hour == world.hour and event.minute == world.minute:
			print("DAMN")

func event(event: NPCScheduleEvent) -> void:
	pass
