extends CharacterBody3D

var data: EnemyData
var health: PoolStat
@export var bar: ProgressBar3D

#@export var health := 10
#@export var damage_label: PackedScene


func _ready() -> void:
	if not data:
		data = EnemyData.new()
	
	if not health:
		health = PoolStat.new(Enums.IntStatType.MAX_HEALTH, Enums.IntStatType.HEALTH_REGEN)

	health.init_with_stats(data.stats)
	health.full_replenish()
	
	print("Enemy ready:")
	print("  EnemyData:", data)
	print("  Stats:", data.stats)
	print("  Max stat:", data.stats.get_stat("MAX_HEALTH"))
	print("  PoolStat.max_stat:", health.max_stat)

func damage(_amt: int) -> void:
	#print(health.value)
	
	health.update(-_amt)
	var f: float = float(health.value) / float(health.max_stat.value)
	
	
	print(health.value)
	print(health.max_stat.value)
	print(f)
	
	bar.set_progress(f)
	#print(health.value / health.max_stat.value)
	
	if health.value <= 0:
		await get_tree().physics_frame
		queue_free()
