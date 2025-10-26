@tool
class_name WorldItemSpawner
extends Node3D

@export_tool_button("spawn_instances") var _spawn = spawn_instances
@export_tool_button("clear_spawned") var _clear = clear_spawned

@export_category("world")
@export var terrain_mesh: MeshInstance3D
@export var terrain_col: CollisionShape3D

@export_category("world item")
@export var prefab: PackedScene
@export_range(0, 5000) var instance_count: int = 200
@export var min_height: float = 0.0
@export var max_height: float = 40.0
@export var random_seed: int = 0

#@export_range(0.0, 360.0) var random_yaw_deg: float = 180.0
#@export_range(0.0, 45.0) var max_tilt_deg: float = 5.0
@export var align_to_normal: bool = true
@export var is_debug_print: bool = true

const MAX_TRIES_PER_INSTANCE: int = 200

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	clear_spawned()
	spawn_instances()

func clear_spawned() -> void:
	for child in get_children():
		child.queue_free()

func spawn_instances() -> void:

	var shape: HeightMapShape3D = terrain_col.shape
	var map_data: PackedFloat32Array = shape.map_data
	
	var map_w: int = shape.map_width
	var map_d: int = shape.map_depth
	
	var plane_size: Vector2 = terrain_mesh.mesh.size

	rng.seed = random_seed

	var tries: int = 0
	var spawned: int = 0
	var total_tries_allowed: int = instance_count * MAX_TRIES_PER_INSTANCE
	
	var spacing_x := plane_size.x / float(max(1, map_w - 1))
	var spacing_z := plane_size.y / float(max(1, map_d - 1))

	while spawned < instance_count and tries < total_tries_allowed:
		tries += 1
		var ix: int = rng.randi_range(0, map_w - 1)
		var iz: int = rng.randi_range(0, map_d - 1)
		#var h: int = 0
		
		var h: float = get_height_from_map_data(map_data, map_w, ix, iz)

		#var h := _height_sample(map_data, map_w, map_d, ix, iz)
		if h < min_height or h > max_height:
			continue

		# compute mesh-local position (plane centered at origin)
		var u := float(ix) / float(max(1, map_w - 1))
		var v := float(iz) / float(max(1, map_d - 1))
		var local_x := (u - 0.5) * plane_size.x
		var local_z := (v - 0.5) * plane_size.y
		var local_pos := Vector3(local_x, h, local_z)
		var world_pos := terrain_mesh.to_global(local_pos)

		# normal from neighboring samples (mesh-local)
		#var normal_local := _normal_from_map(map_data, map_w, map_d, ix, iz, spacing_x, spacing_z)
		#var normal_world := (mesh.global_transform.basis * normal_local).normalized()
		
		#var normal_world := mesh.global_transform.basis.xform(normal_local).normalized()

		# instantiate
		var inst = prefab.instantiate()

		#_holder.add_child(inst)
		#holder.add_child(inst)

		add_child(inst)
		inst.owner = get_tree().edited_scene_root
		
		#inst.global_transform = world_pos
		inst.global_transform = Transform3D(inst.global_transform.basis.orthonormalized(), world_pos)



		#if inst is Node3D:
			#var node := inst as Node3D
			#var node_basis := node.global_transform.basis
			#if align_to_normal:
				#node_basis = _basis_from_up(normal_world)
			## random yaw
			#var yaw := deg_to_rad(rng.randf_range(-random_yaw_deg * 0.5, random_yaw_deg * 0.5))
			#node_basis = node_basis.rotated(normal_world, yaw)
			## small random tilt around basis.x (forward) if requested
			#if max_tilt_deg > 0.0:
				#var tilt := deg_to_rad(rng.randf_range(-max_tilt_deg, max_tilt_deg))
				#node_basis = node_basis.rotated(node_basis.x, tilt)
			#node.global_transform = Transform3D(node_basis.orthonormalized(), world_pos)
		spawned += 1

	print("Spawned %d / %d (tries %d)" % [spawned, instance_count, tries])


func get_height_from_map_data(map_data: PackedFloat32Array, w: int, x: int, z: int) -> float:
	var idx: int = z * w + x
	if idx < 0 or idx >= map_data.size():
		return 0.0
	
	print("x_val: %d, z_val: %d, idx: %d, height: %f" % [x, z, idx, float(map_data[idx])])
	
	return float(map_data[idx])

func get_height_at_index(map_data: PackedFloat32Array, map_size: int, u: int, v: int) -> float:

	if u < 0 or u >= map_size or v < 0 or v >= map_size:
		push_error("u or v out of range: u=%d v=%d map_size=%d" % [u, v, map_size])
		return 0.0

	var idx := v * map_size + u
	return map_data[idx]


#func _normal_from_map(map_data: PackedFloat32Array, w: int, d: int, x: int, z: int, sx: float, sz: float) -> Vector3:
	#var xl = clamp(x - 1, 0, w - 1)
	#var xr = clamp(x + 1, 0, w - 1)
	#var zu = clamp(z - 1, 0, d - 1)
	#var zd = clamp(z + 1, 0, d - 1)
	#var h_l := _height_sample(map_data, w, d, xl, z)
	#var h_r := _height_sample(map_data, w, d, xr, z)
	#var h_u := _height_sample(map_data, w, d, x, zu)
	#var h_d := _height_sample(map_data, w, d, x, zd)
	#var dh_dx := (h_r - h_l) / (2.0 * sx)
	#var dh_dz := (h_d - h_u) / (2.0 * sz)
	#return Vector3(-dh_dx, 1.0, -dh_dz).normalized()

func _basis_from_up(up: Vector3) -> Basis:
	var fwd := Vector3(0,0,1)
	if abs(up.dot(fwd)) > 0.999:
		fwd = Vector3(1,0,0)
	var right := up.cross(fwd).normalized()
	var forward := right.cross(up).normalized()
	return Basis(right, up.normalized(), forward)
