extends Node3D

@export var prefab: PackedScene
@export var marker: Marker3D
@export var timer: Timer

func _ready() -> void:
	timer.connect("timeout", _on_timeout)

func _on_timeout() -> void:
	check_for_children()

func spawn_instance() -> void:
	var inst = prefab.instantiate()
	
	#get_tree().root.add_child(inst)
	add_child(inst)
	
	inst.global_position = marker.global_position

func _physics_process(delta: float) -> void:
	pass

func check_for_children() -> void:
	if get_child_count() > 3:
		return
	else:
		spawn_instance()
