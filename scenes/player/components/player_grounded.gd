class_name PlayerGrounded
extends PlayerComponent

@export var coyote_timer: Timer
@export var jump_buffer_timer: Timer
#@export var air_acceleration_mod: FloatStatModifier = FloatStatModifier.new(0.5, Enums.StatModType.MULTI_M, Enums.FloatStatType.ACCELERATION)

@export var air_jumps: int = 1

var jump_phase: int = 0

func handle_gravity(delta: float) -> void:
	#player.velocity.y -= _stats.gravity.value * delta
	player.velocity.y -= 20.0 * delta

func enter_grounded() -> void:
	jump_phase = air_jumps

func enter_air() -> void:
	#_stats.add_stat_modifier(air_acceleration_mod)
	pass

func exit_air() -> void:
	#_stats.remove_stat_modifier(air_acceleration_mod)
	pass

func handle_jump() -> void:
	player.velocity.y = 8.0
	jump_buffer_timer.stop()

func use_air_jump() -> void:
	jump_phase -= 1

func can_use_jump_buffer() -> bool:
	return not jump_buffer_timer.is_stopped()

func can_air_jump() -> bool:
	return jump_phase > 0
