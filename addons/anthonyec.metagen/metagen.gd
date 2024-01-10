class_name MetaGen
extends Object

class Entry:
	var key: String
	var value: Variant
	var type: Variant.Type
	
	func _init(key: String, value: Variant) -> void:
		self.key = key
		self.value = value
		
	func serialize_value(type: Variant.Type, value: Variant) -> String:
		var serialized_value = str(value)
		
		match type:
			TYPE_STRING, TYPE_STRING_NAME:
				serialized_value = "\"%s\"" % serialized_value
			TYPE_INT, TYPE_FLOAT:
				serialized_value = str(serialized_value)
			TYPE_VECTOR2:
				serialized_value = "Vector2%s" % serialized_value
			TYPE_VECTOR3:
				serialized_value = "Vector3%s" % serialized_value
			TYPE_DICTIONARY:
				var serialized_dictionary = "{"
				
				for key in value:
					var dict_value = value[key]
					serialized_dictionary += "\"%s\": %s, " % \
						[key, serialize_value(typeof(dict_value), dict_value)]
				
				serialized_value = serialized_dictionary.trim_suffix(", ") + "}"
			
			TYPE_ARRAY:
				var serialized_array = "["
				
				for item in value as Array:
					serialized_array += serialize_value(typeof(item), item) + ", "
					
				serialized_value = serialized_array.trim_suffix(", ") + "]"
			_:
				assert(false, "Unsupported value type: %s" % type)
				
		return serialized_value
		
	func _to_string() -> String:
		var serialized_value = serialize_value(typeof(value), value)
		
		return "const %s = %s" % [key, serialized_value]

class Collection:
	var depth: int = -1
	var identifier: String
	var description: String 
	
	var collections: Array[Collection]
	var entries: Array[Entry]

	func _init(identifier: String) -> void:
		self.identifier = identifier
	
	func add_collection(identifier: String) -> Collection:
		assert(not identifier[0].is_valid_float(), "Collection name cannot start with a number")
		
		var collection = Collection.new(identifier)
		
		collection.depth = depth + 1
		collections.append(collection)
		
		return collection
		
	func add_entry(key: String, value: Variant) -> void:
		for entry in entries:
			assert(entry.key != key, "Entry with key \"%s\" already exists in collection \"%s\"" % [key, identifier])
			
		entries.append(Entry.new(key, value))
		
	func _to_string() -> String:
		var is_root = depth == -1
		
		var indent = "\t".repeat(depth) if not is_root else ""
		var nested_indent = "\t".repeat(depth + 1) if not is_root else ""
		
		var serialized_collection = "class_name %s\n\n" % identifier
		
		if not is_root:
			serialized_collection = indent + "class %s:\n" % identifier
			
		for entry in entries:
			serialized_collection += nested_indent + entry._to_string() + "\n"
		
		if not entries.is_empty():
			var serialized_keys: String
			
			var keys: Array = entries.map(func (entry: Entry):
				return entry.key
			)
			
			for key in keys:
				serialized_keys += key + ", "
				
			serialized_collection += nested_indent + "static func get_entries() -> Array: return [%s]" % serialized_keys.trim_suffix(", ")
			serialized_collection += "\n"
			
		if not entries.is_empty():
			serialized_collection += "\n"
			
		for collection in collections:
			serialized_collection += collection._to_string()
		
		if not collections.is_empty():
			serialized_collection += "\n"
			
		if depth > 0 and collections.is_empty() and entries.is_empty():
			serialized_collection += nested_indent + "pass\n\n"
			
		return description + serialized_collection
		
	func to_file(path: String, script_path: String) -> void:
		var file = FileAccess.open(path, FileAccess.WRITE)
		if not file: push_error("Failed to open file to write")
		
		if depth == -1:
			description = "## This is an auto-generated metadata file, do not edit directly.\n"
			description += "## To make changes, edit the script found at: %s\n" % script_path
		
		file.store_string(str(self))
		file.close()
		
		print("Compiled %s" % path)
