extends CharacterBody3D

@export var data: EnemyData = EnemyData.new()
@export var health: PoolStat

#@export var item_slot_data: ItemSlotData
#
#@export var pickup_scene: PackedScene



func _ready() -> void:
	await get_tree().physics_frame
	health.init_with_stats(data.stats)
	health.full_replenish()


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
#
#
#func _on_dropped() -> void:
	#var pickup = pickup_scene.instantiate()
	#pickup.slot_data = item_slot_data
	#get_tree().root.add_child(pickup)
	#pickup.global_position = self.global_position
	#pickup.scale *= 2
