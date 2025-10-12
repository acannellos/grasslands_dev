class_name PlayerHead
extends PlayerComponent3D

@export var camera: Camera3D
#@export var sub_camera: Camera3D
#@export var marker: Marker3D

var max_deg: float = 90
var sensitivity: float = 0.001

#func move_sub_camera() -> void:
	#sub_camera.global_transform = camera.global_transform

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func handle_camera_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.screen_relative.x * sensitivity)
		camera.rotate_x(-event.screen_relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-max_deg), deg_to_rad(max_deg))





#extends Node
#
#@onready var Character : CharacterBody3D = self.get_node(^"CharacterBody3D")
#@onready var Camera : Camera3D = self.get_node(^"CharacterBody3D/Camera3D")
#
#var PrevT : Transform3D
#var ThisT : Transform3D
#
#func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#Camera.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	#PrevT = Camera.global_transform
	#ThisT = Camera.global_transform
	#return
#
#func _input(event: InputEvent) -> void:
	#if(event is InputEventMouseMotion):
		#var T := Transform3D()
		#Camera.rotation.y -= (float(event.screen_relative.x) / float(self.get_window().size.x)) * 2.0
		#Camera.rotation_degrees.x = clampf(rad_to_deg(Camera.rotation.x + ((float(-event.screen_relative.y) / float(self.get_window().size.y)) * 2.0)), -85.0, 85.0)
	#return
#
#func _process(delta: float) -> void:	
	#var Interp := Engine.get_physics_interpolation_fraction()
	#Camera.global_transform = Transform3D(
		#Basis(
			#PrevT.basis.get_rotation_quaternion().normalized().slerp(
				#ThisT.basis.get_rotation_quaternion().normalized(),
				#Interp
			#)
		#),
		#Vector3(
			#PrevT.origin.slerp(
				#ThisT.origin,
				#Interp
			#)
		#)
	#)
	#return
#
#
#func _physics_process(delta: float) -> void:
	#PrevT = ThisT
	#ThisT = Camera.global_transform
	#return
