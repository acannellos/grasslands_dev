extends Node3D

@export var prefab: PackedScene
@export var marker: Marker3D
@export var timer: Timer
@export var max_instances: int = 1

var instances: int = 0

func _ready() -> void:
	timer.connect("timeout", _on_timeout)
	#Events.debug_enemy_died.connect(spawn_enemy)

func _on_timeout() -> void:
	check_for_children()


func spawn_instance() -> void:
	var inst = prefab.instantiate()
	#get_tree().root.add_child(inst)
	add_child(inst)
	inst.global_position = marker.global_position
	#inst.update_target_location(Global.player.global_position)
	instances += 1

func _physics_process(delta: float) -> void:
	pass



	#print(get_children())
func check_for_children() -> void:
	if get_child_count() > 3:
		return
	else:
		spawn_instance()
	
	#
	#if instances >= max_instances:
		##print("yo")
		#return
	#else:
		#await get_tree().create_timer(3.0).timeout
		#spawn_instance()


#
#extends Node3D
#
#@export var enemy_scene: PackedScene
#@export var enemy_flying_scene: PackedScene
#@export var min: float = -1.0
#@export var max: float = 1.0
#@export var spawn_count: int = 10
#
#@onready var marker: Marker3D = $box/Marker3D
#
#func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("spawn"):
		#for spawn in spawn_count:
			#spawn_enemy()
			#Global.enemy_count += 1
#
#func spawn_enemy() -> void:
	#var i: int = randi_range(0,1)
	#var enemy
	#match i:
		#0:
			#enemy = enemy_scene.instantiate()
		#1:
			#enemy = enemy_flying_scene.instantiate()
	#
	##var enemy = enemy_scene.instantiate()
	##get_tree().root.add_child(enemy)
	#marker.add_child(enemy)
	#var vect: Vector3 = Vector3(randf_range(min, max), 0.0, randf_range(min, max))
	#enemy.position = vect
