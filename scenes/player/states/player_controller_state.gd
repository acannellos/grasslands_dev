class_name PlayerControllerState
extends PlayerState
#
#@export var head: PlayerHead
@export var input: PlayerInput
@export var controller: PlayerController
#@export var sprint: PlayerSprint
#@export var slide: PlayerSlide
#@export var dodge: PlayerDodge
#@export var no_clip: PlayerNoClip
#
#@export var col: CollisionShape3D
#
#@export var slide_camera_lerp_speed: float = 8.0
#
enum States {IDLE, RUNNING, SPRINTING, SLIDING, DODGING, DEBUG}
#
func _ready():
	set_state(States.IDLE)

func get_transition():
	
	if input.is_debug_no_clip:
		return States.DEBUG
#
	#if _input.has_dodge:
		#return States.DODGING
#
	#if _input.is_sliding:
			#return States.SLIDING

	if input.input_dir:
		#if _input.is_sprinting and _pools.stamina.value > 0:
			#return States.SPRINTING
		return States.RUNNING
	return States.IDLE
#
#func _enter_state(new_state) -> void:
	##Events.player_move_state_changed.emit(new_state)
	#
	#match new_state:
		#States.SPRINTING:
			#sprint.add_sprint_mods()
		#States.SLIDING:
			#slide.set_direction(_input.input_dir)
			#slide.add_slide_mods()
			#col.disabled = true
		#States.DODGING:
			#dodge.dodge(controller.direction)
			#_input.has_dodge = false
			#set_state(States.IDLE) # TODO add dogde iframes
#
#func _exit_state(old_state) -> void:
	#
	#match old_state:
		#States.SPRINTING:
			#sprint.remove_sprint_mods()
		#States.SLIDING:
			#slide.remove_slide_mods()
			#col.disabled = false
#
func state_logic(delta: float) -> void:
	#head.lerp_head(1.5, slide_camera_lerp_speed * delta)
	match state:
		States.IDLE:
			controller.handle_basic_controller(input.input_dir)
		States.RUNNING:
			controller.handle_basic_controller(input.input_dir)
		#States.SPRINTING:
			#controller.handle_basic_controller(_input.input_dir)
		#States.SLIDING:
			#slide.handle_slide_controller()
			#head.lerp_head(0.5, slide_camera_lerp_speed * delta)
		#States.DODGING:
			#controller.handle_basic_controller(_input.input_dir)
		States.DEBUG:
			controller.handle_no_clip(input.input_dir)
