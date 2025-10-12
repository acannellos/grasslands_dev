class_name IntStatModifier
extends StatModifier

func _init(_mod_value: int = 0, _stat_mod_type: Enums.StatModType = Enums.StatModType.FLAT, _stat_key: Enums.IntStatType = Enums.IntStatType.AIR_JUMPS, _persist_ms = 0.0):
	mod_value = _mod_value
	stat_mod_type = _stat_mod_type
	stat_key = _stat_key
	persist_ms = _persist_ms

@export var stat_key: Enums.IntStatType:
	set(_stat_key):
		stat_key = _stat_key
		key = Enums.get_enum_name(Enums.IntStatType, stat_key)

@export var mod_value: int = 0:
	set(_mod_value):
		mod_value = _mod_value
		value = mod_value
