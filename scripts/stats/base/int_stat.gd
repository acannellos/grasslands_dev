class_name IntStat
extends Stat

func _init(_default_value: int = 0, _stat_key: Enums.IntStatType = Enums.IntStatType.AIR_JUMPS):
	default_value = _default_value
	stat_key = _stat_key

@export var stat_key: Enums.IntStatType:
	set(_stat_key):
		stat_key = _stat_key
		key = Enums.get_enum_name(Enums.IntStatType, stat_key)
		#key = stat_key

@export var default_value: int = 0:
	set(_default_value):
		default_value = _default_value
		base_value = default_value
