class_name PlayerGroundedState
extends PlayerState
#
@export var input: PlayerInput
@export var grounded: PlayerGrounded

enum States {GROUNDED, JUMPING, COYOTE, ONWALL, INAIR}

func _ready():
	set_state(States.INAIR)

func get_transition():
	
	match state:
		States.GROUNDED:
			if can_ground_jump():
				return States.JUMPING
			if not player.is_on_floor():
				return States.COYOTE
		States.JUMPING:
			if player.velocity.y < 0.0:
				return States.INAIR
		States.COYOTE:
			if input.has_jump:
				return States.JUMPING
			if grounded.coyote_timer.is_stopped():
				return States.INAIR
	
	if player.is_on_floor():
		return States.GROUNDED

func enter_state(new_state) -> void:
	match new_state:
		States.COYOTE:
			grounded.coyote_timer.start()
		States.JUMPING:
			grounded.handle_jump()

func state_logic(delta: float) -> void:
	#print(state)
	
	match state:
		States.JUMPING:
			grounded.handle_gravity(delta)
		States.INAIR:
			grounded.handle_gravity(delta)
			if input.has_jump:
				grounded.jump_buffer_timer.start()

func can_ground_jump() -> bool:
	return input.has_jump or not grounded.jump_buffer_timer.is_stopped()







		#States.GROUNDED:
			#if input.has_jump or not grounded.jump_buffer_timer.is_stopped():
			#if can_jump():
				#
				#grounded.handle_jump()
				#grounded.jump_buffer_timer.stop()
				##set_state(States.JUMPING)
		#States.COYOTE:
			#if input.has_jump:
				#grounded.handle_jump()

#@export var wall_jump: PlayerWallJump
#@export var coyote_timer: Timer
#@export var jump_buffer_timer: Timer
#@export var wall_jump_timer: Timer
#

#
#var was_on_floor_last_frame: bool = false
#var is_jump_buffered: bool = false
#


	#if was_on_floor_last_frame and not player.is_on_floor() and not grounded.is_jumping:
		#was_on_floor_last_frame = player.is_on_floor()
		#coyote_timer.start()
		#return States.COYOTE
	#
	#was_on_floor_last_frame = player.is_on_floor()
	#

	#elif player.is_on_wall_only():
		#return States.ONWALL
	#elif not coyote_timer.is_stopped():
		#return States.COYOTE
	
	#else:
		#return States.INAIR
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


		#States.ONWALL:
		#grounded.handle_gravity(delta)
		#if _input.has_jump:
			#if can_jump():
				#grounded.execute_walljump(player.get_wall_normal())
				#_input.has_jump = false
				#return
	
	#grounded.handle_jump(input.has_jump, can_jump())
	#input.has_jump = false
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
#func can_jump() -> bool:
	##return state == States.GROUNDED or state == States.COYOTE or _stats.jump_phase > 0
	#return state == States.GROUNDED
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
