class_name StateMachine
extends Node

var state = null:
	set = set_state
var previous_state = null

func _physics_process(delta: float) -> void:
	if state != null:
		state_logic(delta)
		var transition = get_transition()
		if transition != null:
			set_state(transition)

func state_logic(delta: float) -> void:
	pass

func get_transition():
	return null

func enter_state(new_state) -> void:
	pass

func exit_state(old_state) -> void:
	pass

func set_state(new_state) -> void:
	
	if new_state == state:
		return
	
	previous_state = state
	state = new_state
	
	if previous_state != null:
		exit_state(previous_state)

	if new_state != null:
		enter_state(new_state)
