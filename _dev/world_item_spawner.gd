@tool
class_name WorldItemSpawner
extends Node3D

@export_tool_button("spawn_instances") var _spawn = spawn_instances
@export_tool_button("clear_spawned") var _clear = clear_spawned

@export_category("instance")
@export var terrain: Terrain
@export var prefab: PackedScene
@export_range(0, 5000) var instance_count: int = 200
@export var min_height: float = 0.0
@export var max_height: float = 40.0
@export var random_seed: int = 0

#@export_range(0.0, 360.0) var random_yaw_deg: float = 180.0
#@export_range(0.0, 45.0) var max_tilt_deg: float = 5.0
@export var align_to_normal: bool = true
@export var is_debug_print: bool = true

#@export_range(0.0, 90.0) var max_flat_deg: float = 5.0   # <= this = considered "flat"
#@export_range(0.0, 90.0) var min_sharp_deg: float = 65.0 # >= this = considered "sharp/steep"

@export_range(0.01, 1.0, 0.01) var slope_bias: float = 0.5


const MAX_TRIES_PER_INSTANCE: int = 200

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	if not Engine.is_editor_hint():
		clear_spawned()
		spawn_instances()

func clear_spawned() -> void:
	for child in get_children():
		child.queue_free()

func spawn_instances() -> void:
	
	var shape: HeightMapShape3D = terrain.col.shape
	var map_data: PackedFloat32Array = shape.map_data
	
	var map_w: int = shape.map_width
	var map_d: int = shape.map_depth
	
	var plane_size: Vector2 = terrain.mesh.mesh.size

	rng.seed = random_seed

	var try_count: int = 0
	var spawn_count: int = 0
	var total_tries_allowed: int = instance_count * MAX_TRIES_PER_INSTANCE
	
	var spacing_x := plane_size.x / float(max(1, map_w - 1))
	var spacing_z := plane_size.y / float(max(1, map_d - 1))

	while spawn_count < instance_count and try_count < total_tries_allowed:
		try_count += 1
		var ix: int = rng.randi_range(0, map_w - 1)
		var iz: int = rng.randi_range(0, map_d - 1)
		#var h: int = 0
		
		var h: float = get_height_from_map_data(map_data, map_w, ix, iz) * 2

		#var h := _height_sample(map_data, map_w, map_d, ix, iz)
		if h < min_height or h > max_height:
			continue

		# compute mesh-local position (plane centered at origin)
		var u := float(ix) / float(max(1, map_w - 1))
		var v := float(iz) / float(max(1, map_d - 1))
		var local_x := (u - 0.5) * plane_size.x
		var local_z := (v - 0.5) * plane_size.y
		var local_pos := Vector3(local_x, h, local_z)
		var world_pos := terrain.to_global(local_pos)

		# normal from neighboring samples (mesh-local)
		var normal_local := _normal_from_map(map_data, map_w, map_d, ix, iz, spacing_x, spacing_z)
		var normal_world := (terrain.mesh.global_transform.basis * normal_local).normalized()
		
		var angle_deg := rad_to_deg(acos(clamp(normal_world.dot(Vector3.UP), -1.0, 1.0)))

		## require either "flat" (angle small) or "sharp" (angle large)
		#if not (angle_deg <= max_flat_deg or angle_deg >= min_sharp_deg):
			#continue
		
		var up_dot = clamp(normal_world.dot(Vector3.UP), -1.0, 1.0)

		## map slope_bias 0..1 into thresholds that never hit 0.0
		## - flat_threshold -> higher = stricter (only near-flat pass)
		## - sharp_threshold -> lower = stricter (only very steep pass)
		#var flat_threshold = lerp(0.95, 0.999, slope_bias)   # 0 -> 0.95 (lenient flat), 1 -> 0.999 (only perfect-flat)
		#var sharp_threshold = lerp(0.6, 0.12, slope_bias)     # 0 -> 0.6 (allow mild slopes), 1 -> 0.12 (only very steep)
#
		## safety clamps (never exactly 0)
		#flat_threshold = clamp(flat_threshold, 0.01, 0.9999)
		#sharp_threshold = clamp(sharp_threshold, 0.01, 0.9999)
#
		## accept if sufficiently flat OR sufficiently steep
		#if not (up_dot >= flat_threshold or up_dot <= sharp_threshold):
			#continue


		# map slope_bias 0–1 into a pair of thresholds
		# near 1 → flat; near 0 → steep
		var flat_dot_threshold := 1.0 - slope_bias * 0.2   # 1.0 → 0.8 range
		var sharp_dot_threshold := 0.1 + slope_bias * 0.3  # 0.7 → 1.0 range

		# accept if it’s flat enough or steep enough depending on bias
		var is_flat = up_dot >= flat_dot_threshold
		var is_steep = up_dot <= sharp_dot_threshold
		if not (is_flat or is_steep):
			continue

		var inst = prefab.instantiate()

		add_child(inst)
		
		if Engine.is_editor_hint():
			inst.owner = get_tree().edited_scene_root
		
		inst.global_transform = Transform3D(inst.global_transform.basis.orthonormalized(), world_pos)
		inst.name = "item_" + str(spawn_count + 1)
		if is_debug_print:
			print(inst.global_transform)
		
		
		if align_to_normal:
			inst.global_transform.basis = _basis_from_up(normal_world)

			## random yaw
			#var yaw := deg_to_rad(rng.randf_range(-random_yaw_deg * 0.5, random_yaw_deg * 0.5))
			#node_basis = node_basis.rotated(normal_world, yaw)
			## small random tilt around basis.x (forward) if requested
			#if max_tilt_deg > 0.0:
				#var tilt := deg_to_rad(rng.randf_range(-max_tilt_deg, max_tilt_deg))
				#node_basis = node_basis.rotated(node_basis.x, tilt)
			#node.global_transform = Transform3D(node_basis.orthonormalized(), world_pos)
		
		spawn_count += 1

	#if is_debug_print:
		#print("Spawned %d / %d (tries %d)" % [spawn_count, instance_count, try_count])
		
	print("Spawned %d / %d (tries %d)" % [spawn_count, instance_count, try_count])



func get_height_from_map_data(map_data: PackedFloat32Array, w: int, x: int, z: int) -> float:
	var idx: int = z * w + x
	if idx < 0 or idx >= map_data.size():
		return 0.0
		
	if is_debug_print:
		print("x_val: %d, z_val: %d, idx: %d, height: %f" % [x, z, idx, float(map_data[idx])])
	
	return float(map_data[idx])

func get_height_at_index(map_data: PackedFloat32Array, map_size: int, u: int, v: int) -> float:

	if u < 0 or u >= map_size or v < 0 or v >= map_size:
		push_error("u or v out of range: u=%d v=%d map_size=%d" % [u, v, map_size])
		return 0.0

	var idx := v * map_size + u
	return map_data[idx]


func _normal_from_map(map_data: PackedFloat32Array, w: int, d: int, x: int, z: int, sx: float, sz: float) -> Vector3:
	var xl = clamp(x - 1, 0, w - 1)
	var xr = clamp(x + 1, 0, w - 1)
	var zu = clamp(z - 1, 0, d - 1)
	var zd = clamp(z + 1, 0, d - 1)
	var h_l := get_height_from_map_data(map_data, w, xl, z)
	var h_r := get_height_from_map_data(map_data, w, xr, z)
	var h_u := get_height_from_map_data(map_data, w, x, zu)
	var h_d := get_height_from_map_data(map_data, w, x, zd)
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
