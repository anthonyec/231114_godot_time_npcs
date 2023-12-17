class_name Flags
extends Object

const DEBUG_FPS = "DEBUG_FPS"
const DEBUG_DRAW_NO_DEPTH_TEST = "DEBUG_DRAW_NO_DEPTH_TEST"
const DEBUG_PLAYER = "DEBUG_PLAYER"
const DEBUG_NAV_AGENT = "DEBUG_NAV_AGENT"
const DEBUG_NPCS = "DEBUG_NPCS"
const DEBUG_PLACE_MARKERS = "DEBUG_PLACE_MARKERS"

static var flags: Array[String] = [
	#DEBUG_NPCS
	#DEBUG_FPS,
	#DEBUG_NAV_AGENT,
	DEBUG_DRAW_NO_DEPTH_TEST
	#DEBUG_PLAYER,
]

static func is_enabled(flag: String) -> bool:
	return flags.find(flag) != -1

static func toggle(flag: String) -> void:
	var index = flags.find(flag)
	
	if index == -1:
		flags.append(flag)
		return
		
	flags.remove_at(index)
	
