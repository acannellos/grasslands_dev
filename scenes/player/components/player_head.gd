class_name PlayerHead
extends PlayerComponent3D

@export var camera: Camera3D
@export var sub_camera: Camera3D
#@export var marker: Marker3D

var max_deg: float = 90
var sensitivity: float = 0.001

#var prev_t : Transform3D
#var current_t : Transform3D

func move_sub_camera() -> void:
	sub_camera.global_transform = camera.global_transform

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#camera.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	#prev_t = camera.global_transform
	#current_t = camera.global_transform

func handle_camera_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.screen_relative.x * sensitivity)
		camera.rotate_x(-event.screen_relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-max_deg), deg_to_rad(max_deg))


#
#
#func _input(event: InputEvent) -> void:
	#if (event is InputEventMouseMotion):
		#handle_camera_input(event)
		#var t := Transform3D()
		#camera.rotation.y -= (float(event.screen_relative.x) / float(self.get_window().size.x)) * 2.0
		#camera.rotation_degrees.x = clampf(rad_to_deg(camera.rotation.x + ((float(-event.screen_relative.y) / float(self.get_window().size.y)) * 2.0)), -85.0, 85.0)
	#return
##
#func _process(delta: float) -> void:	
	#var interp := Engine.get_physics_interpolation_fraction()
	#camera.global_transform = Transform3D(
		#Basis(
			#prev_t.basis.get_rotation_quaternion().normalized().slerp(
				#current_t.basis.get_rotation_quaternion().normalized(),
				#interp
			#)
		#),
		#Vector3(
			#prev_t.origin.slerp(
				#current_t.origin,
				#interp
			#)
		#)
	#)
#
#func _physics_process(delta: float) -> void:
	#prev_t = current_t
	#current_t = camera.global_transform
