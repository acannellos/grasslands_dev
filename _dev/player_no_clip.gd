class_name PlayerNoClip
extends PlayerComponent

@export var player_col: CollisionShape3D
@export var speed_multi: float = 10.0

func handle_no_clip(in_bool: bool) -> void:
	
	player_col.disabled = in_bool
	
	var new_input_dir: Vector2
	var new_direction: Vector3
	new_input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	if new_input_dir:
		new_direction = player.head.camera.global_transform.basis * Vector3(new_input_dir.x, 0, new_input_dir.y)
		new_direction.normalized()
	else:
		new_direction = Vector3.ZERO
	
	#var _speed: float = _stats.speed.value * speed_multi
	#var _acceleration: float = _stats.acceleration.value
	
	var _speed: float = 10.0 * speed_multi
	var _acceleration: float = 0.25
	
	player.velocity = lerp(player.velocity, new_direction * _speed, _acceleration)
	player.move_and_slide()
