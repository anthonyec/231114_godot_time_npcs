class_name NPCScheduleEvent
extends Resource

enum TravelType {
	WALK,
	RUN,
	TELEPORT,
}

enum Task {
	NONE,
	WANDER,
}

# Who is it for.
@export var npc: String

# When to start leaving for destination.
@export_range(0, 23) var hour: int
@export_range(0, 59) var minute: int
@export var days: Array[int]

## Where in the world to go to.
@export var level: String
@export var place: String

# How to get to the destination.
@export var travel_type: TravelType

# What to do when at the destination.
@export var task: Task

func get_timestamp() -> int:
	# https://stackoverflow.com/a/51011191
	return minute * 60 + hour * 3600

func _to_string() -> String:
	# TODO: Improve info in string, e.g name and time.
	return "NPCScheduleEvent npc=\"" + str(npc) + "\" h=\"" + str(hour) + "\" m=\"" + str(minute) + "\">"
