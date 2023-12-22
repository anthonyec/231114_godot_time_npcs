@tool
class_name NavigationMeshWalls
extends Node3D

@export var navigation_region: NavigationRegion3D

func _ready() -> void:
	if not navigation_region: return
	navigation_region.bake_finished.connect(_on_navigation_region_bake_finished)
	
func _on_navigation_region_bake_finished() -> void:
	# TODO: Implement walls using `navigation_region.navigation_mesh.polygons`
	pass
