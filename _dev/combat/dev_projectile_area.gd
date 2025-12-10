extends Area3D

@export var speed: float = 50.0
var lifetime: float = 10.0

var og_pos: Vector3

var my_gravity: float = 10.0
var vertical_velocity: float = 0.0 

func _ready():
	await get_tree().create_timer(0.1).timeout
	connect("body_entered", Callable(self, "_on_body_entered"))
	#area_entered.connect(_on_area_entered)
	og_pos = global_position

func _physics_process(delta):
	
	#position += global_basis * Vector3.FORWARD * delta * speed
	
	vertical_velocity -= my_gravity * delta
	
	var forward_motion = global_basis * Vector3.FORWARD * speed
	var gravity_motion = Vector3(0, vertical_velocity, 0)
	
	position += (forward_motion + gravity_motion) * delta
	
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()

func _on_body_entered(body):
	if body.has_method("damage"):
		var dmg = 5
		body.damage(dmg)
	
	Draw.point(global_position, 3, Color(1,1,1,0.2), 2)
	queue_free()

func set_speed(custom_speed: float) -> void:
	speed = custom_speed

#func _on_area_entered(area) -> void:
	#look_at(og_pos)
	#set_speed(speed * 2)
	#print("entered")
