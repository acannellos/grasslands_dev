class_name PlayerInput
extends PlayerComponent

#@export var is_toggle_sprint: bool = false

var is_debug_no_clip: bool = false
var input_dir: Vector2
#var is_sprinting: bool = false
#var is_sliding: bool = false
#var has_dodge: bool = false
var has_jump: bool = false

var is_primary_just_pressed: bool = false
var is_primary_pressed: bool = false
var is_primary_just_released: bool = false

var ability_index: int = 0

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("debug_no_clip"):
		is_debug_no_clip = !is_debug_no_clip
	
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	#if is_toggle_sprint:
		#if Input.is_action_just_pressed("sprint"):
			#is_sprinting = !is_sprinting
	#else:
		#if Input.is_action_pressed("sprint"):
			#is_sprinting = true
		#else:
			#is_sprinting = false
	#
	#if Input.is_action_pressed("slide"):
		#is_sliding = true
	#else:
		#is_sliding = false
	
	#if Input.is_action_just_pressed("dodge") and _stats.can_dodge.value: # TODO and phase
		#has_dodge = true
	
	if Input.is_action_just_pressed("jump"):
		has_jump = true
	else:
		has_jump = false
	#
	#if Input.is_action_just_pressed("interact"):
		#pass

	is_primary_just_pressed = Input.is_action_just_pressed("primary")
	is_primary_pressed = Input.is_action_pressed("primary")
	is_primary_just_released = Input.is_action_just_released("primary")



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			ability_index = (ability_index + 1) % player.data.abilities.size()
			Events.player_ability_changed.emit(ability_index)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			ability_index = (ability_index - 1)
			if ability_index < 0:
				ability_index = player.data.abilities.size() - 1
			Events.player_ability_changed.emit(ability_index)

#func change_ability() -> void:
	#if Input.is_action_just_pressed("ability_next"):
		#ability_index = (ability_index + 1) % player.data.abilities.size()
		#set_ability(ability_index)
	#
	#if Input.is_action_just_pressed("ability_prev"):
		#ability_index = (ability_index - 1)
		#if ability_index < 0:
			#ability_index = player.data.abilities.size() - 1
		#set_ability(ability_index)
