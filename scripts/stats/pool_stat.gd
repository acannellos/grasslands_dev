class_name PoolStat
#extends Node
extends Resource

@export var max_type: Enums.IntStatType:
	set(_stat_key):
		max_type = _stat_key
		max_key = Enums.get_enum_name(Enums.IntStatType, max_type)

@export var regen_type: Enums.IntStatType:
	set(_stat_key):
		regen_type = _stat_key
		regen_key = Enums.get_enum_name(Enums.IntStatType, regen_type)

var max_key
var regen_key
#var _stats: Stats
var max_stat: IntStat
var regen_stat: IntStat
var min_value: int = 0
var accumulator: float = 0.0
var value: int = 0:
	get:
		return clamp(value, min_value, max_stat.value)

#func _ready() -> void:
	#_stats = owner.data.stats
	#max_stat = _stats.get_stat(max_key)
	#regen_stat = _stats.get_stat(regen_key)
	##full_replenish()

func init_with_stats(stats: Stats) -> void:
	max_stat = stats.get_stat(Enums.get_enum_name(Enums.IntStatType, max_type))
	regen_stat = stats.get_stat(Enums.get_enum_name(Enums.IntStatType, regen_type))
	#full_replenish()

func update(to_update: int) -> void:
	value = clamp(value + to_update, min_value, max_stat.value)

func apply_regen(delta: float) -> void:
	accumulator += regen_stat.value * delta
	var whole_effect = int(accumulator)
	if whole_effect != 0:
		accumulator -= whole_effect
		update(whole_effect)

func full_replenish() -> void:
	value = max_stat.value

func full_deplete() -> void:
	value = min_value

func is_full() -> bool:
	return max_stat.value == value

func is_empty() -> bool:
	return min_value == value
