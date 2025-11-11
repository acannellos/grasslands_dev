class_name PlayerGrounded
extends PlayerComponent

@export var coyote_timer: Timer
@export var jump_buffer_timer: Timer
#@export var controller: PlayerController
#@export var dodge: PlayerDodge
#@export var air_acceleration_mod: FloatStatModifier = FloatStatModifier.new(0.5, Enums.StatModType.MULTI_M, Enums.FloatStatType.ACCELERATION)

@export var air_jumps: int = 1

var jump_phase: int = 0

func _ready() -> void:
	jump_phase = air_jumps

func handle_gravity(delta: float) -> void:
	#player.velocity.y -= _stats.gravity.value * delta
	player.velocity.y -= 20.0 * delta

#func enter_grounded() -> void:
	#_stats.jump_phase = _stats.air_jumps.value
	#Events.player_grounded.emit()
#
#func enter_air() -> void:
	#_stats.add_stat_modifier(air_acceleration_mod)
#
#func exit_air() -> void:
	#_stats.remove_stat_modifier(air_acceleration_mod)

func handle_jump() -> void:
	player.velocity.y = 8.0
	jump_buffer_timer.stop()
	#Events.player_jumped.emit()

	#var impulse_multiplier: float = 20.0
	#if dodge.is_dodge_jump:
		#player.velocity.x += controller.direction.x * _stats.dodge_range.value * impulse_multiplier
		#player.velocity.y += _stats.dodge_range.value * impulse_multiplier * 2.0
		#player.velocity.z += controller.direction.z * _stats.dodge_range.value * impulse_multiplier
#
	#player.velocity.y = _stats.jump_height.value

#func execute_walljump(wall_norm: Vector3) -> void:
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
