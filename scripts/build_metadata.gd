## Generate a `Metdata` class that contains the names of all the levels,
## places and dialogues. This can be accessed statically (not at run-time) and 
## thus will trigger errors if names of the data changes, making things less 
## "stringly" typed.
##
## Regenerate the metdata using File > Run while viewing this file.

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
	var characters = get_files("res://narrative/characters")
	
	var metadata = MetaGen.Collection.new("Metadata")
	
	var levels_collection = metadata.add_collection("Levels")
	var cameras_collection = metadata.add_collection("Cameras")
	var places_collection = metadata.add_collection("Places")
	var dialogues_collection = metadata.add_collection("Dialogues")
	var characters_collection = metadata.add_collection("Characters")
	
	for level in levels:
		var scene_path = "res://levels/%s/%s.tscn" % [level, level]
		var scene = load(scene_path) as PackedScene
		var level_node = scene.instantiate()
		
		var level_identifier = level.to_snake_case().to_upper()
		var level_places_collection = places_collection.add_collection(level.to_pascal_case())
		
		for child in level_node.get_children():
			var child_identifier = child.name.to_snake_case().to_upper()
			
			if child is Camera3D:
				cameras_collection.add_entry(level_identifier + "_" + child_identifier, level_node.name + "/" + child.name)
				
			if child is PlaceMarker:
				
				level_places_collection.add_entry(child_identifier, child.name)
				places_collection.add_entry(level_identifier + "__" + child_identifier, child.name)
				
		levels_collection.add_entry(level.to_upper(), level)
		
	for dialogue in dialogues:
		dialogues_collection.add_entry(dialogue.to_snake_case().to_upper(), dialogue)
		
	for character in characters:
		characters_collection.add_entry(character.to_snake_case().to_upper(), character)
	
	metadata.to_file("res://metadata.gd", "res://scripts/build_metadata.gd")
