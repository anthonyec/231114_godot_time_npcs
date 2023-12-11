class_name PlaceMarker
extends Marker3D

func _process(_delta: float) -> void:
	if Flags.is_enabled(Flags.DEBUG_PLACE_MARKERS):
		DebugDraw.set_text("Place " + name, "", global_position)
