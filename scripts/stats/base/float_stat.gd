class_name FloatStat
extends Stat

func _init(_default_value: float = 0.0, _stat_key: Enums.FloatStatType = Enums.FloatStatType.SPEED):
	default_value = _default_value
	stat_key = _stat_key

@export var stat_key: Enums.FloatStatType:
	set(_stat_key):
		stat_key = _stat_key
		key = Enums.get_enum_name(Enums.FloatStatType, stat_key)
		#key = stat_key

@export var default_value: float = 0.0:
	set(_default_value):
		default_value = _default_value
		base_value = default_value
