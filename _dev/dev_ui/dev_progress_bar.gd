@tool
extends MeshInstance3D

@export_tool_button("Increase Progress", "ArrowUp") var _increase
@export_tool_button("Decrease Progress", "ArrowDown") var _decrease

@export var tween_speed := 0.5
@export var current_value := 1.0

var mat : ShaderMaterial

func _enter_tree():
	if Engine.is_editor_hint():
		set_process(true)

func _ready():
	_increase = test_increase_progress
	_decrease = test_decrease_progress
	set_mat()

func set_mat():
	mat = get_active_material(0) as ShaderMaterial
	if mat == null:
		push_error("No ShaderMaterial found on this MeshInstance3D!")

func test_increase_progress():
	set_progress(current_value + 0.1)

func test_decrease_progress():
	set_progress(current_value - 0.1)

func set_progress(target: float):
	if not is_inside_tree():
		return
	if mat == null:
		set_mat()

	target = clamp(target, 0.0, 1.0)
	current_value = target  # this is the "logical" progress

	var current_bar = mat.get_shader_parameter("value")
	var current_lag = mat.get_shader_parameter("lag_value")

	var tw := create_tween()

	if target > current_bar:
		# Increasing: lag_value jumps to target instantly, bar tweens from current_bar to target
		mat.set_shader_parameter("lag_value", target)
		tw.tween_method(func(v): mat.set_shader_parameter("value", v), current_bar, target, tween_speed)
	elif target < current_bar:
		# Decreasing: value jumps to target instantly, lag_value tweens from current_lag to target
		mat.set_shader_parameter("value", target)
		tw.tween_method(func(v): mat.set_shader_parameter("lag_value", v), current_lag, target, tween_speed)
