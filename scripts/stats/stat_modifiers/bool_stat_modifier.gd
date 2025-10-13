class_name BoolStatModifier
extends StatModifier

func _init(_mod_value: bool = false, _stat_key: Enums.BoolStatType = Enums.BoolStatType.CAN_MOVE, _persist_ms = 0.0):
	mod_value = _mod_value
	stat_key = _stat_key
	persist_ms = _persist_ms

@export var stat_key: Enums.BoolStatType:
	set(_stat_key):
		stat_key = _stat_key
		key = Enums.get_enum_name(Enums.BoolStatType, stat_key)

@export var mod_value: bool = false:
	set(_mod_value):
		mod_value = _mod_value
		value = mod_value
