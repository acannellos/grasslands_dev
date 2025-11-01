class_name PlayerGrounded
extends PlayerComponent

@export var coyote_timer: Timer
@export var jump_buffer_timer: Timer
#@export var controller: PlayerController
#@export var dodge: PlayerDodge
#@export var air_acceleration_mod: FloatStatModifier = FloatStatModifier.new(0.5, Enums.StatModType.MULTI_M, Enums.FloatStatType.ACCELERATION)
#
#var is_jumping: bool = false

@export var air_jumps: int = 1


var jump_phase: int = 0
var was_on_floor_last_frame: bool = false
var is_jump_buffered: bool = false

func _ready() -> void:
	jump_phase = air_jumps
	pass
	#coyote_timer.connect("timeout", _on_coyote_timer_timeout)
	#jump_buffer_timer.connect("timeout", _on_jump_buffer_timer_timeout)

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


func handle_jump() -> void:

	player.velocity.y = 8.0
	jump_buffer_timer.stop()

#func handle_jump_buffer() -> void:
	##if has_jump:
		##if can_jump:
	#player.velocity.y = 8.0

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

#func is_coyote_time(has_jump: bool) -> bool:
	#if not coyote_timer.is_stopped():
		#return true
	#
	#if was_on_floor_last_frame and not player.is_on_floor() and not has_jump:
		#was_on_floor_last_frame = false
		#coyote_timer.start()
		#return true
	#
	#was_on_floor_last_frame = player.is_on_floor()
	#return false




#func _physics_process(delta: float) -> void:
	#if was_on_floor_last_frame and not player.is_on_floor():
		#coyote_timer.start()
		#
	#was_on_floor_last_frame = player.is_on_floor()


#func handle_coyote_time() -> void:
	#if player.velocity.y < 0.0:
		#pass

#func handle_coyote_time() -> void:
	#if was_on_floor_last_frame:
		#coyote_timer.start()
		#
	#was_on_floor_last_frame = player.is_on_floor()

#func update_was_on_floor_last_frame() -> void:
	##was_on_floor_last_frame = player.is_on_floor()
	#pass

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

#func _on_coyote_timer_timeout() -> void:
	#set_state(States.INAIR)
#
#func _on_jump_buffer_timer_timeout() -> void:
	#is_jump_buffered = false

#func buffer_jump() -> void:
	#is_jump_buffered = true
	#jump_buffer_timer.start()

#func _use_air_jump() -> void:
	#if state == States.INAIR and not is_jump_buffered:
		#_stats.jump_phase -= 1
		#Events.player_air_jump_updated.emit(_stats.jump_phase)


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
