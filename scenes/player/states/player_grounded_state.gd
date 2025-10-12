class_name PlayerGroundedState
extends PlayerState
#
@export var grounded: PlayerGrounded
#@export var wall_jump: PlayerWallJump
#@export var coyote_timer: Timer
#@export var jump_buffer_timer: Timer
#@export var wall_jump_timer: Timer
#
enum States {GROUNDED, COYOTE, ONWALL, INAIR}
#
#var was_on_floor_last_frame: bool = false
#var is_jump_buffered: bool = false
#
func _ready():
	set_state(States.INAIR)
	##coyote_timer.connect("timeout", _on_coyote_timer_timeout)
	#jump_buffer_timer.connect("timeout", _on_jump_buffer_timer_timeout)
#
func get_transition():
	#
	#if was_on_floor_last_frame and not player.is_on_floor() and not grounded.is_jumping:
		#was_on_floor_last_frame = player.is_on_floor()
		#coyote_timer.start()
		#return States.COYOTE
	#
	#was_on_floor_last_frame = player.is_on_floor()
	#
	if player.is_on_floor():
		return States.GROUNDED
	#elif player.is_on_wall_only():
		#return States.ONWALL
	#elif not coyote_timer.is_stopped():
		#return States.COYOTE
	else:
		return States.INAIR
#
#func _enter_state(new_state) -> void:
	#
	#match new_state:
		#States.GROUNDED:
			#grounded.enter_grounded()
		#States.ONWALL:
			#
			#if wall_jump.should_timer_start:
				#wall_jump_timer.start()
				#wall_jump.should_timer_start = false
		#States.INAIR:
			#grounded.enter_air()
#
#func _exit_state(old_state) -> void:
	#match old_state:
		#States.INAIR:
			#grounded.exit_air()
#
func state_logic(delta: float) -> void:
	
	match state:
		#States.ONWALL:
			#grounded.handle_gravity(delta)
			#if _input.has_jump:
				#if can_jump():
					#grounded.execute_walljump(player.get_wall_normal())
					#_input.has_jump = false
					#return
		States.INAIR:
			grounded.handle_gravity(delta)
	#
	grounded.handle_jump(_input.has_jump, can_jump())
	_input.has_jump = false
#
#func _handle_jump() -> void:
	#if _input.has_jump:
		#if can_jump():
			#grounded.execute_jump()
			#is_jump_buffered = false
			#_use_air_jump()
			#emit_ground_jump()
		#else:
			#buffer_jump()
		#
		#_input.has_jump = false
#
	#if is_jump_buffered and can_jump():
		#grounded.execute_jump()
		#emit_ground_jump()
		#is_jump_buffered = false
#
func can_jump() -> bool:
	#return state == States.GROUNDED or state == States.COYOTE or _stats.jump_phase > 0
	return state == States.GROUNDED
#
#func buffer_jump() -> void:
	#is_jump_buffered = true
	#jump_buffer_timer.start()
#
#func emit_ground_jump() -> void:
	#if state == States.GROUNDED or state == States.COYOTE and _input.has_jump:
		#Events.player_jumped.emit()
#
#func _on_coyote_timer_timeout() -> void:
	#set_state(States.INAIR)
#
#func _on_jump_buffer_timer_timeout() -> void:
	#is_jump_buffered = false
#
#func _use_air_jump() -> void:
	#if state == States.INAIR and not is_jump_buffered:
		#_stats.jump_phase -= 1
		#Events.player_air_jump_updated.emit(_stats.jump_phase)
