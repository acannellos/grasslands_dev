class_name BoolStat
extends Stat

func _init(_default_value: bool = false, _stat_key: Enums.BoolStatType = Enums.BoolStatType.CAN_MOVE):
	default_value = _default_value
	stat_key = _stat_key

@export var stat_key: Enums.BoolStatType:
	set(_stat_key):
		stat_key = _stat_key
		key = Enums.get_enum_name(Enums.BoolStatType, stat_key)
		#key = stat_key

@export var default_value: bool = false:
	set(_default_value):
		default_value = _default_value
		base_value = default_value
