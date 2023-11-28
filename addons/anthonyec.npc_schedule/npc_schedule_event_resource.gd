class_name NPCScheduleEvent
extends Resource

# Who is it for.
@export var npc: String

# When to start leaving for destination.
@export_range(0, 23) var start_hour: int
@export_range(0, 59) var start_minute: int
@export_range(0, 23) var end_hour: int
@export_range(0, 59) var end_minute: int

## Where in the world to go to.
@export var level: String
@export var location: String

func get_start_imestamp() -> int:
	return start_minute * 60 + start_hour * 3600
	
func get_end_imestamp() -> int:
	return end_minute * 60 + end_hour * 3600

func _to_string() -> String:
	# TODO: Improve info in string, e.g name and time.
	return "NPCScheduleEvent npc=\"" + npc + "\" h=\"" + str(start_hour) + "\" m=\"" + str(start_minute) + "\">"
