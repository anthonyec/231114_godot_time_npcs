## This is an auto-generated metadata file, do not edit directly.
## To make changes, edit the script found at: res://scripts/build_metadata.gd
class_name Metadata

class Levels:
	const TEST_ROOM = "test_room"
	const TEST_ROOM_2 = "test_room_2"
	const CAFE_WALK = "cafe_walk"
	const PIER = "pier"
	static func get_entries() -> Array: return [TEST_ROOM, TEST_ROOM_2, CAFE_WALK, PIER]

class Cameras:
	const TEST_ROOM_CAMERA_1 = "TestRoom/Camera1"
	const TEST_ROOM_CAMERA_2 = "TestRoom/Camera2"
	const TEST_ROOM_CAMERA_3 = "TestRoom/Camera3"
	const TEST_ROOM_2_CAMERA_1 = "TestRoom/Camera1"
	const TEST_ROOM_2_CAMERA_2 = "TestRoom/Camera2"
	const CAFE_WALK_FULL_SCENE = "Pier/FullScene"
	const CAFE_WALK_UNDER_BRIDGE = "Pier/UnderBridge"
	const CAFE_WALK_BRIDGE = "Pier/Bridge"
	const CAFE_WALK_CAFE_BACK = "Pier/CafeBack"
	const CAFE_WALK_CAFE_SIDE = "Pier/CafeSide"
	const PIER_CAMERA_3D_0 = "Pier/Camera3D0"
	const PIER_PIER_SIDE_CAMERA = "Pier/PierSideCamera"
	const PIER_CAMERA_3D_2 = "Pier/Camera3D2"
	const PIER_BEACH_CAMERA = "Pier/BeachCamera"
	static func get_entries() -> Array: return [TEST_ROOM_CAMERA_1, TEST_ROOM_CAMERA_2, TEST_ROOM_CAMERA_3, TEST_ROOM_2_CAMERA_1, TEST_ROOM_2_CAMERA_2, CAFE_WALK_FULL_SCENE, CAFE_WALK_UNDER_BRIDGE, CAFE_WALK_BRIDGE, CAFE_WALK_CAFE_BACK, CAFE_WALK_CAFE_SIDE, PIER_CAMERA_3D_0, PIER_PIER_SIDE_CAMERA, PIER_CAMERA_3D_2, PIER_BEACH_CAMERA]

class Places:
	const TEST_ROOM__SAFE_SPAWN = "SafeSpawn"
	const TEST_ROOM__BOTTOM_OF_STAIRS = "BottomOfStairs"
	const TEST_ROOM__BEHIND_STAIRS = "BehindStairs"
	const TEST_ROOM__TOP_OF_STAIRS = "TopOfStairs"
	const CAFE_WALK__SAFE_SPAWN = "SafeSpawn"
	const CAFE_WALK__CAFE_SIDE_BIT = "CafeSideBit"
	const PIER__PLAYER = "Player"
	const PIER__BOATMAN = "Boatman"
	const PIER__YASUKO = "Yasuko"
	const PIER__MITSUKO = "Mitsuko"
	const PIER__SHIGERU = "Shigeru"
	const PIER__TAKESHI = "Takeshi"
	const PIER__GENTA = "Genta"
	const PIER__YASUKOS_SISTER = "Yasukos_Sister"
	const PIER__SIMON = "Simon"
	const PIER__OFF_STAGE = "OffStage"
	const PIER__PLAYER_EXIT_BOAT = "PlayerExitBoat"
	const PIER__MITSUKO_STAND_NEAR_PLAYER = "MitsukoStandNearPlayer"
	const PIER__YASUKO_STAND_NEAR_PARENTS = "YasukoStandNearParents"
	const PIER__YASUKOS_SISTER_WAVE = "YasukosSisterWave"
	const PIER__YASUKOS_SISTER_KNEEL = "YasukosSisterKneel"
	const PIER__PIER_END_LOWER = "PierEndLower"
	const PIER__PIER_END_MIDDLE = "PierEndMiddle"
	const PIER__PIER_END_UPPER = "PierEndUpper"
	const PIER__END_PIER_LAMPOST = "EndPierLampost"
	const PIER__MIDDLE_PIER_LOWER = "MiddlePierLower"
	const PIER__MIDDLE_PIER_UPPER = "MiddlePierUpper"
	const PIER__START_PIER_MIDDLE = "StartPierMiddle"
	const PIER__BEACH = "Beach"
	const PIER__SAFE_SPAWN = "SafeSpawn"
	static func get_entries() -> Array: return [TEST_ROOM__SAFE_SPAWN, TEST_ROOM__BOTTOM_OF_STAIRS, TEST_ROOM__BEHIND_STAIRS, TEST_ROOM__TOP_OF_STAIRS, CAFE_WALK__SAFE_SPAWN, CAFE_WALK__CAFE_SIDE_BIT, PIER__PLAYER, PIER__BOATMAN, PIER__YASUKO, PIER__MITSUKO, PIER__SHIGERU, PIER__TAKESHI, PIER__GENTA, PIER__YASUKOS_SISTER, PIER__SIMON, PIER__OFF_STAGE, PIER__PLAYER_EXIT_BOAT, PIER__MITSUKO_STAND_NEAR_PLAYER, PIER__YASUKO_STAND_NEAR_PARENTS, PIER__YASUKOS_SISTER_WAVE, PIER__YASUKOS_SISTER_KNEEL, PIER__PIER_END_LOWER, PIER__PIER_END_MIDDLE, PIER__PIER_END_UPPER, PIER__END_PIER_LAMPOST, PIER__MIDDLE_PIER_LOWER, PIER__MIDDLE_PIER_UPPER, PIER__START_PIER_MIDDLE, PIER__BEACH, PIER__SAFE_SPAWN]

	class TestRoom:
		const SAFE_SPAWN = "SafeSpawn"
		const BOTTOM_OF_STAIRS = "BottomOfStairs"
		const BEHIND_STAIRS = "BehindStairs"
		const TOP_OF_STAIRS = "TopOfStairs"
		static func get_entries() -> Array: return [SAFE_SPAWN, BOTTOM_OF_STAIRS, BEHIND_STAIRS, TOP_OF_STAIRS]

	class TestRoom2:
		pass

	class CafeWalk:
		const SAFE_SPAWN = "SafeSpawn"
		const CAFE_SIDE_BIT = "CafeSideBit"
		static func get_entries() -> Array: return [SAFE_SPAWN, CAFE_SIDE_BIT]

	class Pier:
		const PLAYER = "Player"
		const BOATMAN = "Boatman"
		const YASUKO = "Yasuko"
		const MITSUKO = "Mitsuko"
		const SHIGERU = "Shigeru"
		const TAKESHI = "Takeshi"
		const GENTA = "Genta"
		const YASUKOS_SISTER = "Yasukos_Sister"
		const SIMON = "Simon"
		const OFF_STAGE = "OffStage"
		const PLAYER_EXIT_BOAT = "PlayerExitBoat"
		const MITSUKO_STAND_NEAR_PLAYER = "MitsukoStandNearPlayer"
		const YASUKO_STAND_NEAR_PARENTS = "YasukoStandNearParents"
		const YASUKOS_SISTER_WAVE = "YasukosSisterWave"
		const YASUKOS_SISTER_KNEEL = "YasukosSisterKneel"
		const PIER_END_LOWER = "PierEndLower"
		const PIER_END_MIDDLE = "PierEndMiddle"
		const PIER_END_UPPER = "PierEndUpper"
		const END_PIER_LAMPOST = "EndPierLampost"
		const MIDDLE_PIER_LOWER = "MiddlePierLower"
		const MIDDLE_PIER_UPPER = "MiddlePierUpper"
		const START_PIER_MIDDLE = "StartPierMiddle"
		const BEACH = "Beach"
		const SAFE_SPAWN = "SafeSpawn"
		static func get_entries() -> Array: return [PLAYER, BOATMAN, YASUKO, MITSUKO, SHIGERU, TAKESHI, GENTA, YASUKOS_SISTER, SIMON, OFF_STAGE, PLAYER_EXIT_BOAT, MITSUKO_STAND_NEAR_PLAYER, YASUKO_STAND_NEAR_PARENTS, YASUKOS_SISTER_WAVE, YASUKOS_SISTER_KNEEL, PIER_END_LOWER, PIER_END_MIDDLE, PIER_END_UPPER, END_PIER_LAMPOST, MIDDLE_PIER_LOWER, MIDDLE_PIER_UPPER, START_PIER_MIDDLE, BEACH, SAFE_SPAWN]


class Dialogues:
	const INTRO = "intro"
	const BOKU = "boku"
	const TEST = "test"
	static func get_entries() -> Array: return [INTRO, BOKU, TEST]

class Characters:
	const GENTA = "genta"
	const YASUKOS_SISTER = "yasukos_sister"
	const PLAYER = "player"
	const SIMON = "simon"
	const BOATMAN = "boatman"
	const MITSUKO = "mitsuko"
	const SHIGERU = "shigeru"
	const TAKESHI = "takeshi"
	const YASUKO = "yasuko"
	static func get_entries() -> Array: return [GENTA, YASUKOS_SISTER, PLAYER, SIMON, BOATMAN, MITSUKO, SHIGERU, TAKESHI, YASUKO]


