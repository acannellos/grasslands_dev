extends Node3D


#extends Area3D

@export var speed: float = 50.0
var lifetime: float = 10.0

var og_pos: Vector3

func _ready():
	await get_tree().create_timer(0.1).timeout
	#connect("body_entered", Callable(self, "_on_body_entered"))
	#area_entered.connect(_on_area_entered)
	og_pos = global_position

func _physics_process(delta):
	
	position += global_basis * Vector3.FORWARD * delta * speed
	
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()

#func _on_body_entered(body):
	#if body.has_method("damage"):
		#var dmg = 1
		#body.damage(dmg)
#
	#queue_free()

func set_speed(custom_speed: float) -> void:
	speed = custom_speed

#func _on_area_entered(area) -> void:
	#look_at(og_pos)
	#set_speed(speed * 2)
	#print("entered")
