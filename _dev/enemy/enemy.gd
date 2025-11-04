extends CharacterBody3D

@export var data: EnemyData = EnemyData.new()
@export var health: PoolStat
@export var timer: Timer

#@export var item_slot_data: ItemSlotData
#@export var pickup_scene: PackedScene

@export var is_dummy: bool = false
#@export var health := 10
#@export var damage_label: PackedScene
@export var speed: float = 8.0

@export var movement_speed: float = 4.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

func _ready() -> void:
	timer.connect("timeout", _on_timeout)
	health.init_with_stats(data.stats)
	health.full_replenish()
	set_movement_target(Global.player.global_position)
	
	#await get_tree().physics_frame
	#set_physics_process(false)
	#await get_tree().create_timer(3.0).timeout
	#set_physics_process(true)
	##navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	#await get_tree().physics_frame

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	
	_move_ai_new()

func _on_timeout() -> void:
	set_movement_target(Global.player.global_position)

func _move_ai_new():
	var dir: Vector3 = global_position.direction_to(navigation_agent.get_next_path_position())
	velocity = dir * 8.0
	move_and_slide()


func damage(_amt: int) -> void:
	#print(health.value)
	health.update(-_amt)
	#print(-_amt)
	print(health.value)
	
	
	#handle_damage_label(_amt)
	#health -= amount
	
	if health.value <= 0:
		#_on_dropped()
		#Events.debug_enemy_died.emit()
		await get_tree().physics_frame
		queue_free()
		#destroy()


#@export var damage_label: PackedScene
#@export var offset: Vector3 = Vector3.ZERO

#
#func handle_damage_label(_amt: int) -> void:
	#if damage_label:
		#var new_label = damage_label.instantiate() as Label3D
		#new_label.text = str(_amt)
		#get_tree().root.add_child(new_label)
		##var rand: float = randf_range(-1.0, 1.0)
		#var rand_vect: Vector3 =  Vector3(randf_range(-1.0, 1.0), randf_range(0.0, 1.0), randf_range(-1.0, 1.0))
		#new_label.global_position = global_position + offset + rand_vect



#
#func _on_dropped() -> void:
	#var pickup = pickup_scene.instantiate()
	#pickup.slot_data = item_slot_data
	#get_tree().root.add_child(pickup)
	#pickup.global_position = self.global_position
	#pickup.scale *= 2




#@export var offset: Vector3 = Vector3.ZERO
#
#@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
#
#var destroyed: bool = false
#

	#var new_mat: StandardMaterial3D = StandardMaterial3D.new()
#
#func _physics_process(delta: float) -> void:
	#if not is_dummy:
		##update_target_location(Global.player.global_transform.origin)
		#move_ai()
#
#func move_ai() -> void:
	##await get_tree().physics_frame
	##var current_loc: Vector3 = global_transform.origin
	#var current_loc: Vector3 = global_position
	#if nav_agent:
		#var next_loc: Vector3 = nav_agent.get_next_path_position()
		#var new_vel = (next_loc - current_loc).normalized() * speed
		#velocity = new_vel
		#move_and_slide()
	#
##
#func update_target_location(target_loc: Vector3) -> void:
	#nav_agent.target_position = target_loc
#
#func damage(amount):
	#Audio.play("sounds/enemy_hurt.ogg")
#
	#if not is_dummy:
		#health -= amount
#
		#if health <= 0 and !destroyed:
			#destroy()
	#
	#if damage_label:
		#var new_label = damage_label.instantiate() as Label3D
		#new_label.text = str(amount)
		#get_tree().root.add_child(new_label)
		##var rand: float = randf_range(-1.0, 1.0)
		#var rand_vect: Vector3 =  Vector3(randf_range(-1.0, 1.0), randf_range(0.0, 1.0), randf_range(-1.0, 1.0))
		#new_label.global_position = global_position + offset + rand_vect
#
## Destroy the enemy when out of health
#
#func destroy():
	#Audio.play("sounds/enemy_destroy.ogg")
	#Global.enemy_count -= 1
	#
	#destroyed = true
	#queue_free()
