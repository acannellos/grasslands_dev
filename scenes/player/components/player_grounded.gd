class_name PlayerGrounded
extends PlayerComponent
#
#@export var controller: PlayerController
#@export var dodge: PlayerDodge
#@export var air_acceleration_mod: FloatStatModifier = FloatStatModifier.new(0.5, Enums.StatModType.MULTI_M, Enums.FloatStatType.ACCELERATION)
#
#var is_jumping: bool = false
#

func handle_gravity(delta: float) -> void:
	#player.velocity.y -= _stats.gravity.value * delta
	player.velocity.y -= 20.0 * delta

#func enter_grounded() -> void:
	#_stats.jump_phase = _stats.air_jumps.value
	#Events.player_grounded.emit()
	#Events.player_air_jump_updated.emit(_stats.jump_phase)
	#is_jumping = false
#
#func enter_air() -> void:
	#_stats.add_stat_modifier(air_acceleration_mod)
#
#func exit_air() -> void:
	#_stats.remove_stat_modifier(air_acceleration_mod)


func handle_jump(has_jump: bool, can_jump: bool) -> void:
	if has_jump:
		if can_jump:
			player.velocity.y = 8.0
			#grounded.execute_jump()
			#is_jump_buffered = false
			#_use_air_jump()
			#emit_ground_jump()
		#else:
			#buffer_jump()

	#if is_jump_buffered and can_jump():
		#grounded.execute_jump()
		#emit_ground_jump()
		#is_jump_buffered = false


#func execute_jump() -> void:
	#is_jumping = true
	#
	#
	##Events.player_jumped.emit()
	#
	#var impulse_multiplier: float = 20.0
	#if dodge.is_dodge_jump:
		#player.velocity.x += controller.direction.x * _stats.dodge_range.value * impulse_multiplier
		#player.velocity.y += _stats.dodge_range.value * impulse_multiplier * 2.0
		#player.velocity.z += controller.direction.z * _stats.dodge_range.value * impulse_multiplier
#
	#player.velocity.y = _stats.jump_height.value
#
#func execute_walljump(wall_norm: Vector3) -> void:
	#is_jumping = true
#
	## Clear vertical speed (optional)
	#player.velocity.y = 0
#
	## Define forces
	#var wall_jump_horizontal := wall_norm.normalized() * 60.0
	#var wall_jump_vertical := Vector3.UP * 10.0
#
	## Combine forces manually
	#player.velocity = wall_jump_horizontal + wall_jump_vertical
#
	##print("Wall jump velocity: ", player.velocity)
#
