class_name Stat
extends Resource

@export var stat_modifiers: Array[StatModifier] = []

var key
var base_value
var _cached_value = base_value
var _is_dirty: bool = true

var value:
	get:
		if not _is_dirty:
			return _cached_value
		else:
			compute()
			return _cached_value

func compute() -> void:
	if not stat_modifiers:
		_cached_value = base_value
		_is_dirty = false
		return
	
	var computed = base_value
	var flat_mod = 0
	var multi_add_mod = 0.0
	var multi_multi_mod = 1.0
	var needs_multi_mod: bool = false
	
	for stat_modifier in stat_modifiers:
		if stat_modifier is BoolStatModifier:
			_cached_value = stat_modifier.value
			_is_dirty = false
			return
		
		match stat_modifier.stat_mod_type:
			Enums.StatModType.FLAT:
				flat_mod += stat_modifier.value
			Enums.StatModType.MULTI_A:
				multi_add_mod += stat_modifier.value
			Enums.StatModType.MULTI_M:
				multi_multi_mod *= stat_modifier.value
				needs_multi_mod = true
	
	computed += flat_mod
	computed *= 1 + multi_add_mod
	#if multi_multi_mod != 0:
	if needs_multi_mod:
		computed *= multi_multi_mod

	_cached_value = computed
	needs_multi_mod = false
	_is_dirty = false

func add_stat_modifier(stat_modifier: StatModifier) -> void:
	stat_modifiers.append(stat_modifier)
	_is_dirty = true

func remove_stat_modifier(stat_modifier: StatModifier) -> void:
	stat_modifiers.erase(stat_modifier)
	_is_dirty = true

func clear_stat_modifiers() -> void:
	stat_modifiers = []
	_is_dirty = true
