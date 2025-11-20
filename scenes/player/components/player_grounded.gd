class_name PlayerGrounded
extends PlayerComponent

@export var coyote_timer: Timer
@export var jump_buffer_timer: Timer

var air_acceleration_mod: FloatStatModifier = FloatStatModifier.new(0.5, Enums.StatModType.MULTI_M, Enums.FloatStatType.ACCELERATION)

var jump_phase: int = 0

func handle_gravity(delta: float) -> void:
	player.velocity.y -= _stats.gravity.value * delta

func enter_grounded() -> void:
	jump_phase = _stats.air_jumps.value

func enter_air() -> void:
	_stats.add_stat_modifier(air_acceleration_mod)

func exit_air() -> void:
	_stats.remove_stat_modifier(air_acceleration_mod)

func handle_jump() -> void:
	player.velocity.y = 8.0
	jump_buffer_timer.stop()

func use_air_jump() -> void:
	jump_phase -= 1

func can_use_jump_buffer() -> bool:
	return not jump_buffer_timer.is_stopped()

func can_air_jump() -> bool:
	return jump_phase > 0
