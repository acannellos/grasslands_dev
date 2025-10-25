@tool
extends Node

@export var mesh: MeshInstance3D
@export var col: CollisionShape3D            # must hold a HeightMapShape3D
@export var prefab: PackedScene

@export_range(0, 5000) var instance_count: int = 200
@export var min_height: float = 0.0
@export var max_height: float = 40.0
@export var plane_size: Vector2 = Vector2(512, 512) # world extents of the heightmap (X,Z)
@export var random_seed: int = 0

@export_range(0.0, 360.0) var random_yaw_deg: float = 180.0
@export_range(0.0, 45.0) var max_tilt_deg: float = 5.0  # small random tilt around local forward
@export var align_to_normal: bool = true

@export_tool_button("spawn_instances") var _spawn = spawn_instances
@export_tool_button("clear_spawned") var _clear = clear_spawned

const MAX_TRIES_PER_INSTANCE := 200
var rng := RandomNumberGenerator.new()
var _holder: Node3D

func _ready() -> void:
	if not has_node("Spawned"):
		_create_holder()
	else:
		spawn_instances()

func _create_holder() -> void:
	if _holder and is_instance_valid(_holder): return
	_holder = Node3D.new()
	_holder.name = "Spawned"
	add_child(_holder)
	if Engine.is_editor_hint():
		_holder.owner = owner

func clear_spawned() -> void:
	if _holder and is_instance_valid(_holder):
		_holder.free()
	_holder = null
	_create_holder()

func spawn_instances() -> void:
	if prefab == null or col == null or mesh == null:
		push_error("prefab / col / mesh must be set")
		return

	var shape := col.shape
	if not (shape is HeightMapShape3D):
		push_error("CollisionShape3D must contain a HeightMapShape3D")
		return

	var map_w := int(shape.map_width)
	var map_d := int(shape.map_depth)
	var map_data = shape.map_data
	#if map_w <= 0 or map_d <= 0 or map_data.empty():
		#push_error("HeightMapShape3D has invalid data")
		#return

	rng.seed = random_seed
	_create_holder()

	var tries := 0
	var spawned := 0
	var total_tries_allowed := instance_count * MAX_TRIES_PER_INSTANCE
	var spacing_x := plane_size.x / float(max(1, map_w - 1))
	var spacing_z := plane_size.y / float(max(1, map_d - 1))

	while spawned < instance_count and tries < total_tries_allowed:
		tries += 1
		var ix := rng.randi_range(0, map_w - 1)
		var iz := rng.randi_range(0, map_d - 1)
		var h := _height_sample(map_data, map_w, map_d, ix, iz)
		if h < min_height or h > max_height:
			continue

		# compute mesh-local position (plane centered at origin)
		var u := float(ix) / float(max(1, map_w - 1))
		var v := float(iz) / float(max(1, map_d - 1))
		var local_x := (u - 0.5) * plane_size.x
		var local_z := (v - 0.5) * plane_size.y
		var local_pos := Vector3(local_x, h, local_z)
		var world_pos := mesh.to_global(local_pos)
		#var world_pos := mesh.global_transform.xform(local_pos)

		# normal from neighboring samples (mesh-local)
		var normal_local := _normal_from_map(map_data, map_w, map_d, ix, iz, spacing_x, spacing_z)
		var normal_world := (mesh.global_transform.basis * normal_local).normalized()
		#var normal_world := mesh.global_transform.basis.xform(normal_local).normalized()

		# instantiate
		var inst := prefab.instantiate()
		if inst == null:
			push_error("failed to instantiate prefab")
			return
		_holder.add_child(inst)

		if inst is Node3D:
			var node := inst as Node3D
			var basis := node.global_transform.basis
			if align_to_normal:
				basis = _basis_from_up(normal_world)
			# random yaw
			var yaw := deg_to_rad(rng.randf_range(-random_yaw_deg * 0.5, random_yaw_deg * 0.5))
			basis = basis.rotated(normal_world, yaw)
			# small random tilt around basis.x (forward) if requested
			if max_tilt_deg > 0.0:
				var tilt := deg_to_rad(rng.randf_range(-max_tilt_deg, max_tilt_deg))
				basis = basis.rotated(basis.x, tilt)
			node.global_transform = Transform3D(basis.orthonormalized(), world_pos)
		spawned += 1

	print("Spawned %d / %d (tries %d)" % [spawned, instance_count, tries])

# --- helpers ---
func _height_sample(map_data: PackedFloat32Array, w: int, d: int, x: int, z: int) -> float:
	var idx := z * w + x
	if idx < 0 or idx >= map_data.size():
		return 0.0
	return float(map_data[idx])

func _normal_from_map(map_data: PackedFloat32Array, w: int, d: int, x: int, z: int, sx: float, sz: float) -> Vector3:
	var xl = clamp(x - 1, 0, w - 1)
	var xr = clamp(x + 1, 0, w - 1)
	var zu = clamp(z - 1, 0, d - 1)
	var zd = clamp(z + 1, 0, d - 1)
	var h_l := _height_sample(map_data, w, d, xl, z)
	var h_r := _height_sample(map_data, w, d, xr, z)
	var h_u := _height_sample(map_data, w, d, x, zu)
	var h_d := _height_sample(map_data, w, d, x, zd)
	var dh_dx := (h_r - h_l) / (2.0 * sx)
	var dh_dz := (h_d - h_u) / (2.0 * sz)
	return Vector3(-dh_dx, 1.0, -dh_dz).normalized()

func _basis_from_up(up: Vector3) -> Basis:
	var fwd := Vector3(0,0,1)
	if abs(up.dot(fwd)) > 0.999:
		fwd = Vector3(1,0,0)
	var right := up.cross(fwd).normalized()
	var forward := right.cross(up).normalized()
	return Basis(right, up.normalized(), forward)

func _get_configuration_warning() -> String:
	if mesh == null: return "Assign mesh"
	if col == null: return "Assign CollisionShape3D (HeightMapShape3D)"
	if prefab == null: return "Assign prefab"
	return ""
