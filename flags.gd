class_name Flags
extends Object

const DEBUG_FPS = "DEBUG_FPS"
const DEBUG_DRAW_NO_DEPTH_TEST = "DEBUG_DRAW_NO_DEPTH_TEST"
const DEBUG_PLAYER = "DEBUG_PLAYER"
const DEBUG_NAV_AGENT = "DEBUG_NAV_AGENT"

static var flags: Array[String] = [
	DEBUG_FPS,
	DEBUG_NAV_AGENT,
#	DEBUG_DRAW_NO_DEPTH_TEST
	DEBUG_PLAYER,
]

static func is_enabled(flag: String) -> bool:
	return flags.find(flag) != -1
