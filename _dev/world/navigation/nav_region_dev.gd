extends NavigationRegion3D

#func _ready() -> void:
	#Events.heightmap_finished.connect(on_heightmap_finished)


func on_heightmap_finished() -> void:
	bake_navigation_mesh()
