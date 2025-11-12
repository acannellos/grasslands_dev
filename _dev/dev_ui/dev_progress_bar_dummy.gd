class_name ProgressBar3D
extends MeshInstance3D

@export var tween_speed := 0.5
@export var current_value := 1.0

var mat : ShaderMaterial
#var tw: Tween

func _ready():
	set_mat()
	#tw = get_tree().create_tween()

#func _ready():
	#var base_mat = get_active_material(0) as ShaderMaterial
	#if base_mat:
		#mat = base_mat.duplicate()

func set_mat():
	mat = get_active_material(0) as ShaderMaterial
	if mat == null:
		push_error("No ShaderMaterial found on this MeshInstance3D!")



func set_progress(target: float):
	if not is_inside_tree():
		return
	if mat == null:
		set_mat()

	target = clamp(target, 0.0, 1.0)
	current_value = target

	var current_bar = mat.get_shader_parameter("value")
	var current_lag = mat.get_shader_parameter("lag_value")

	# If no change, skip everything
	if is_equal_approx(target, current_bar):
		return

	if target > current_bar:
		mat.set_shader_parameter("lag_value", target)
		var tw := get_tree().create_tween()
		tw.tween_method(func(v): mat.set_shader_parameter("value", v), current_bar, target, tween_speed)
	else:
		mat.set_shader_parameter("value", target)
		var tw := get_tree().create_tween()
		tw.tween_method(func(v): mat.set_shader_parameter("lag_value", v), current_lag, target, tween_speed)
#
#
#
#
#
#
#
#
#
#func set_progress(target: float):
	#if not is_inside_tree():
		#return
	#if mat == null:
		#set_mat()
#
	#target = clamp(target, 0.0, 1.0)
	#current_value = target  # this is the "logical" progress
#
	#var current_bar = mat.get_shader_parameter("value")
	#var current_lag = mat.get_shader_parameter("lag_value")
#
	#tw = get_tree().create_tween()
#
	#if target > current_bar:
		## Increasing: lag_value jumps to target instantly, bar tweens from current_bar to target
		#mat.set_shader_parameter("lag_value", target)
		#tw.tween_method(func(v): mat.set_shader_parameter("value", v), current_bar, target, tween_speed)
	#elif target < current_bar:
		## Decreasing: value jumps to target instantly, lag_value tweens from current_lag to target
		#mat.set_shader_parameter("value", target)
		#tw.tween_method(func(v): mat.set_shader_parameter("lag_value", v), current_lag, target, tween_speed)
