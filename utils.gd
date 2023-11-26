class_name Utils

static func get_closest(nodes: Array[Variant], target: Node3D) -> Node3D:
	var shortest_distance = INF
	var closest_node: Node3D = null
	
	for node in nodes:
		if not (node is Node3D): continue
		node = node as Node3D
			
		var distance = node.global_position.distance_squared_to(target.global_position)
		
		if distance < shortest_distance:
			shortest_distance = distance
			closest_node = node
			
	return closest_node
