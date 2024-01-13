@tool
extends DialogicEvent
class_name DialogicCameraEvent

var camera_name: String

func _execute() -> void:
	var world = World.instance
	if not world: return finish()
	
	var cameras = world.get_cameras()
	var target_camera: Camera3D
	
	# TODO: Add world helper to switch to camera by name.
	for camera in cameras:
		if camera.name == camera_name:
			target_camera = camera
			break

	if not target_camera:
		push_warning("Camera not found called: %s" % camera_name)
		return finish()
	
	target_camera.make_current()
	finish()

func _init() -> void:
	event_name = "Switch Camera"
	event_category = "Stage"

func get_shortcode() -> String:
	return "switch_camera"

func get_shortcode_parameters() -> Dictionary:
	return {
		"name": { "property": "camera_name", "default": "wow" },
	}

func build_event_editor() -> void:
	var cameras = Metadata.Cameras.get_entries()
	
	var selector_options = cameras.map(func(camera_name: String):
		return {
			"label": camera_name,
			"value": camera_name.split("/")[1] # TODO: This isn't great.
		}
	)
	
	add_header_edit("camera_name", ValueType.FIXED_OPTION_SELECTOR, {
		"placeholder": "Select camera",
		"left_text": "Switch to camera",
		'selector_options': selector_options
	})
