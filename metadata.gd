## This is an auto-generated metadata file, do not edit directly.
## To make changes, edit the script found at: res://scripts/build_metadata.gd
class_name Metadata

class Levels:
	const TEST_ROOM = "test_room"
	const TEST_ROOM_2 = "test_room_2"
	const CAFE_WALK = "cafe_walk"
	const PIER = "pier"
	static func all() -> Array[String]: return [TEST_ROOM, TEST_ROOM_2, CAFE_WALK, PIER]

class Places:
	class TestRoom:
		const SAFE_SPAWN = "SafeSpawn"
		const BOTTOM_OF_STAIRS = "BottomOfStairs"
		const BEHIND_STAIRS = "BehindStairs"
		const TOP_OF_STAIRS = "TopOfStairs"
		static func all() -> Array[String]: return [SAFE_SPAWN, BOTTOM_OF_STAIRS, BEHIND_STAIRS, TOP_OF_STAIRS]

	class TestRoom2:
		pass

	class CafeWalk:
		const SAFE_SPAWN = "SafeSpawn"
		const CAFE_SIDE_BIT = "CafeSideBit"
		static func all() -> Array[String]: return [SAFE_SPAWN, CAFE_SIDE_BIT]

	class Pier:
		const PIER_END_LOWER = "PierEndLower"
		const PIER_END_MIDDLE = "PierEndMiddle"
		const PIER_END_UPPER = "PierEndUpper"
		const END_PIER_LAMPOST = "EndPierLampost"
		const MIDDLE_PIER_LOWER = "MiddlePierLower"
		const MIDDLE_PIER_UPPER = "MiddlePierUpper"
		const START_PIER_MIDDLE = "StartPierMiddle"
		const BEACH = "Beach"
		const SAFE_SPAWN = "SafeSpawn"
		static func all() -> Array[String]: return [PIER_END_LOWER, PIER_END_MIDDLE, PIER_END_UPPER, END_PIER_LAMPOST, MIDDLE_PIER_LOWER, MIDDLE_PIER_UPPER, START_PIER_MIDDLE, BEACH, SAFE_SPAWN]

class Dialogues:
	const INTRO = "intro"
	const BOKU = "boku"
	const TEST = "test"
	static func all() -> Array[String]: return [INTRO, BOKU, TEST]

