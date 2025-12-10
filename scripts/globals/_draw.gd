class_name Draw

static func line(start_pos: Vector3, end_pos: Vector3, color = Color.WHITE_SMOKE, persist_ms = 0, parent: Node = null):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	#immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP, material)
	immediate_mesh.surface_add_vertex(start_pos)
	immediate_mesh.surface_add_vertex(end_pos)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = color

	return await _final_cleanup(mesh_instance, persist_ms, parent)

static func point(pos: Vector3, radius = 0.05, color = Color.WHITE_SMOKE, persist_ms = 0, parent: Node = null):
	var mesh_instance := MeshInstance3D.new()
	var sphere_mesh := SphereMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = sphere_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance.position = pos

	sphere_mesh.radius = radius
	sphere_mesh.height = radius * 2
	sphere_mesh.material = material

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = color

	return await _final_cleanup(mesh_instance, persist_ms, parent)

static func square(pos: Vector3, basis: Basis, size: Vector3, color = Color.WHITE_SMOKE, persist_ms = 0, parent: Node = null):
	var mesh_instance := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = box_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	mesh_instance.position = pos
	mesh_instance.basis = basis
	
	#mesh_instance.global_position = pos
	#mesh_instance.global_basis = basis

	box_mesh.size = size
	box_mesh.material = material

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	material.cull_mode = BaseMaterial3D.CULL_FRONT
	#material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = color
	#material.metallic = 0.0
	#material.roughness = 0.0

	return await _final_cleanup(mesh_instance, persist_ms, parent)

static func line_as_vertical_ribbon(start_pos: Vector3, end_pos: Vector3, color := Color.WHITE_SMOKE, width := 0.1, persist_ms := 0, parent: Node = null):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	# Center points for the start and end
	var mid1 := start_pos
	var mid2 := end_pos

	# Get direction vector from pos1 to pos2 (vertical span)
	var vertical_dir := (end_pos - start_pos).normalized()

	# For vertical ribbons, side direction is perpendicular to vertical
	# Use a fixed forward vector to define width direction
	var forward := Vector3.FORWARD
	if abs(vertical_dir.dot(forward)) > 0.95:
		forward = Vector3.RIGHT  # Avoid degenerate cross product

	var side := forward.cross(vertical_dir).normalized() * (width * 0.5)

	# Compute quad corners
	var v1 := mid1 - side
	var v2 := mid1 + side
	var v3 := mid2 - side
	var v4 := mid2 + side
	
	# Compute quad corners
	side = Vector3(0,0.1,0)

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES, material)
	immediate_mesh.surface_add_vertex(v1)
	immediate_mesh.surface_add_vertex(v2)
	immediate_mesh.surface_add_vertex(v3)

	immediate_mesh.surface_add_vertex(v3)
	immediate_mesh.surface_add_vertex(v2)
	immediate_mesh.surface_add_vertex(v4)
	immediate_mesh.surface_end()

	# Material settings
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CullMode.CULL_DISABLED
	material.albedo_color = color

	return await _final_cleanup(mesh_instance, persist_ms, parent)


## 1 -> Lasts ONLY for current physics frame
## >1 -> Lasts X time duration.
## <1 -> Stays indefinitely
static func _final_cleanup(mesh_instance: MeshInstance3D, persist_ms: float, parent: Node):
	if parent:
		parent.add_child(mesh_instance)
	else:
		Global.get_tree().root.add_child(mesh_instance)
		
	if persist_ms == 1:
		await Global.get_tree().physics_frame
		mesh_instance.queue_free()
	elif persist_ms > 0:
		await Global.get_tree().create_timer(persist_ms).timeout
		mesh_instance.queue_free()
	else:
		return mesh_instance
