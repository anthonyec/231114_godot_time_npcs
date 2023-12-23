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
	var dialogue = get_files("res://dialogue")
	
	var file: String
	
	file += "## This file has been auto-generated!\n"
	file += "## Don't edit directly, instead edit the script found at:\n"
	file += "## ./scripts/build_metadata.gd \n\n"
	file += "class_name Metadata\n"
	file += "extends Object\n"
	
	file += "\n"
	
	# Dialogue.
	file += "class Dialogues:\n"
	
	for name in dialogue:
		var identifier = name.to_snake_case().to_upper()
		file += "\tconst " + identifier + " = " + "\"" + name + "\"" + "\n"
		
	file += "\n"
	
	# Levels.
	file += "class Levels:\n"
	
	for name in levels:
		var identifier = name.to_snake_case().to_upper()
		file += "\tconst " + identifier + " = " + "\"" + name + "\"" + "\n"
		
	file += "\n"
	
	# Places.
	file += "class Places:\n"
	
	for name in levels:
		var scene_path = "res://levels/%s/%s.tscn" % [name, name]
		var scene = load(scene_path) as PackedScene
		var level = scene.instantiate()
		
		file += "\tclass %s:\n" % name.to_pascal_case()
		
		for child in level.get_children():
			if child is PlaceMarker:
				var identifier = child.name.to_snake_case().to_upper()
				file += "\t\tconst %s = \"%s\"\n" % [identifier, child.name]
				
		file += "\t\tpass\n\n"
		
		level.queue_free()
		
	# var places_class = file.add_class("Places")
	#
	# for name in levels:
	# 	var place_class = places_class.add_class(name.to_pascal_case())
	#
	#	for child in level.get_children():
	#		place_class.add_const(identifier, child.name)
	
		
	var script = FileAccess.open("res://metadata.gd", FileAccess.WRITE)
	if not script: push_error("Failed to open file to write")
	
	script.store_string(file)
	script.close()
	
	print("Compiled meatadata.gd")
	
