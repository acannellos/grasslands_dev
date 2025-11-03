extends Marker3D

@export var input: PlayerInput

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D


var rotation_multiplier: float = 0.2
var smooth_speed: float = 5.0

var sway_frequency: float = 8.0
var sway_amount: float = 0.02

var original_rotation: Vector3 = Vector3.ZERO
var sway_time: float = 0.0
var base_position: Vector3 = Vector3.ZERO

func _ready() -> void:
	original_rotation = rotation
	base_position = position
	#Events.player_dodge_used.connect(_on_player_dodge_used)

func _physics_process(delta: float) -> void:
	_update_rotation(delta)
	_update_sway(delta)

func _update_rotation(delta: float) -> void:
	var target_rotation: Vector3 = original_rotation
	target_rotation.x += input.input_dir.y * rotation_multiplier
	target_rotation.z += -input.input_dir.x * rotation_multiplier

	rotation = rotation.lerp(target_rotation, delta * smooth_speed)

func _update_sway(delta: float) -> void:
	if input.input_dir.length() > 0.01:
		sway_time += delta
		var sway_offset: Vector3 = Vector3(0.0, sin(sway_time * sway_frequency) * sway_amount, 0.0)
		transform.origin = base_position + sway_offset
	else:
		sway_time = 0.0
		position = lerp(position, base_position, delta * smooth_speed)

#func _on_player_dodge_used() -> void:
	#mesh_instance_3d.transparency = 0.5
	#await get_tree().create_timer(0.3).timeout
	#mesh_instance_3d.transparency = 0.0
