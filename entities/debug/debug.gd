class_name Debug
extends Node

func _process(_delta: float) -> void:
	var world = World.instance
	
	DebugDraw.set_text("Time", world.get_display_time() + " Day: " + str(world.day))
	
	if Input.is_action_pressed("ui_up"):
		world.tick_per_milliseconds = 0
	else:
		world.tick_per_milliseconds = 1000
		
	if Input.is_key_pressed(KEY_1):
		Game.instance.load_level("test_room")
	
