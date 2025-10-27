class_name PlayerController
extends PlayerComponent

var direction: Vector3

func handle_basic_controller(_input_dir: Vector2) -> void:
	
	if _input_dir:
		direction = player.head.transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)
		direction.normalized()
	else:
		direction = Vector3.ZERO
	
	#var _speed: float = _stats.speed.value
	#var _acceleration: float = _stats.acceleration.value
	
	var _speed: float = 10.0
	var _acceleration: float = 0.25
	
	player.velocity.x = lerp(player.velocity.x, direction.x * _speed, _acceleration)
	player.velocity.z = lerp(player.velocity.z, direction.z * _speed, _acceleration)
	
	player.move_and_slide()

#@export var player_col: CollisionShape3D
@export var debug_speed_multi: float = 10.0

func handle_no_clip(_input_dir: Vector2) -> void:
	
	var new_direction: Vector3
	
	if _input_dir:
		new_direction = player.head.camera.global_transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)
		new_direction.normalized()
	else:
		new_direction = Vector3.ZERO
	
	#var _speed: float = _stats.speed.value * speed_multi
	#var _acceleration: float = _stats.acceleration.value
	
	var _speed: float = 10.0 * debug_speed_multi
	var _acceleration: float = 0.25
	
	player.velocity = lerp(player.velocity, new_direction * _speed, _acceleration)
	player.move_and_slide()
