class_name NPCSchedule
extends Node

var schedule: Array[Dictionary] = [
	{
		"npc": "mark",
		"start_time": [9, 0],
		"end_time": [9, 20],
		"level": "test_room",
		"location": "TopOfStairs"
	},
	{
		"npc": "mark",
		"start_time": [10, 00],
		"end_time": [10, 30],
		"level": "test_room",
		"location": "BottomOfStairs"
	},
	{
		"npc": "john",
		"start_time": [8, 30],
		"end_time": [9, 0],
		"level": "test_room",
		"location": "BottomOfStairs"
	},
	{
		"npc": "john",
		"start_time": [9, 50],
		"end_time": [13, 0],
		"level": "test_room",
		"location": "BehindStairs"
	}
]

func _ready() -> void:
	var world = World.instance
	world.minute_tick.connect(_on_world_minute_tick)
	
func _on_world_minute_tick() -> void:
	var world = World.instance
	var events = get_events_for_time(world.hour, world.minute)
	
	for event in events:
		var npc_name = event.get("npc")
		assert(npc_name, "Expected event to have npc")
		
		var existing_npc = world.find_npc_or_null(npc_name)
		
		if existing_npc:
			existing_npc.set_schedule_event(event)

func get_timestamp(hour: int, minute: int) -> int:
	# https://stackoverflow.com/a/51011191
	return minute * 60 + hour * 3600

func get_events_for_time(hour: int, minute: int) -> Array[Dictionary]:
	var current_timestamp = get_timestamp(hour, minute)
	var events: Array[Dictionary] = []
	
	for event in schedule:
		var start_time = event.get("start_time")
		var end_time = event.get("end_time")
		assert(start_time != null and end_time != null, "Expected event to have start and end time")
		
		var start_timestamp = get_timestamp(start_time[0], start_time[1])
		var end_timestamp = get_timestamp(end_time[0], end_time[1])
		
		if current_timestamp >= start_timestamp and current_timestamp <= end_timestamp:
			events.append(event)
		
	return events
