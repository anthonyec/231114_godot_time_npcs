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

static func is_near(from: Vector3, to: Vector3, tolerance: Vector3 = Vector3(0, 0, 0)) -> bool:
	var distance = Vector3(
		to.x - from.x,
		to.y - from.y,
		to.z - from.z,
	).abs()
	
	return distance.x < tolerance.x and distance.y < tolerance.y and distance.z < tolerance.z
