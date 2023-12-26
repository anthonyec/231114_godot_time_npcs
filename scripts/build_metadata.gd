@tool
extends EditorScript

func get_files(path: String) -> Array[String]:
	var files: Array[String]
	
	var directory = DirAccess.open(path)
	if not directory: return files
	
	directory.list_dir_begin()
	
	var filename = directory.get_next()
	
	while filename:
		if filename.get_extension() != "import":
			var name_without_extension = filename.replace("." + filename.get_extension(), "")
			files.append(name_without_extension)
		
		filename = directory.get_next()
		
	return files

func _run() -> void:
	var levels = get_files("res://levels")
	var dialogues = get_files("res://dialogue")
	
	var metadata = MetaGen.Collection.new("Metadata")
	var levels_collection = metadata.add_collection("Levels")
	var places_collection = metadata.add_collection("Places")
	var dialogues_collection = metadata.add_collection("Dialogues")
	
	for level in levels:
		var scene_path = "res://levels/%s/%s.tscn" % [level, level]
		var scene = load(scene_path) as PackedScene
		var level_node = scene.instantiate()
		
		var level_places_collection = places_collection.add_collection(level.to_pascal_case())
		
		for child in level_node.get_children():
			if child is PlaceMarker:
				level_places_collection.add_entry(child.name.to_snake_case().to_upper(), child.name)
				
		levels_collection.add_entry(level.to_upper(), level)
		
	for dialogue in dialogues:
		dialogues_collection.add_entry(dialogue.to_snake_case().to_upper(), dialogue)
	
	metadata.to_file("res://metadata.gd", "res://scripts/build_metadata.gd")
	print("Compiled meatadata.gd")
