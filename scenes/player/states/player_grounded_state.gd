class_name PlayerGroundedState
extends PlayerState

@export var input: PlayerInput
@export var grounded: PlayerGrounded

enum States {GROUNDED, JUMPING, COYOTE, ONWALL, INAIR}

func _ready():
	set_state(States.INAIR)

func get_transition():
	match state:
		States.GROUNDED:
			if input.has_jump or grounded.can_use_jump_buffer():
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
		States.INAIR:
			if input.has_jump and grounded.can_air_jump():
				grounded.use_air_jump()
				return States.JUMPING
	
	if player.is_on_floor():
		return States.GROUNDED

func enter_state(new_state) -> void:
	match new_state:
		States.GROUNDED:
			grounded.enter_grounded()
		States.COYOTE:
			grounded.coyote_timer.start()
		States.JUMPING:
			grounded.handle_jump()
		States.INAIR:
			grounded.enter_air()

func _exit_state(old_state) -> void:
	match old_state:
		States.INAIR:
			grounded.exit_air()

func state_logic(delta: float) -> void:
	
	#print(Enums.get_enum_name(States, state))
	
	match state:
		States.JUMPING:
			grounded.handle_gravity(delta)
			if input.has_jump and grounded.can_air_jump():
				grounded.use_air_jump()
				grounded.handle_jump()

		States.INAIR:
			grounded.handle_gravity(delta)
			if input.has_jump:
				grounded.jump_buffer_timer.start()
