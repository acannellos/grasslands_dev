class_name PlayerInput
extends PlayerComponent

#@export var is_toggle_sprint: bool = false

var is_debug_no_clip: bool = false
var input_dir: Vector2
#var is_sprinting: bool = false
#var is_sliding: bool = false
#var has_dodge: bool = false
var has_jump: bool = false

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
