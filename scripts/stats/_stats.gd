@abstract
class_name Stats
extends Resource

func _init() -> void:
	get_map()

var map: Dictionary:
	get = get_map

func get_map() -> Dictionary:
	var new_map = {}

	for property in get_property_list():
		
		if property.get("usage") != 4102: # if not exported
			continue

		var stat = get(property.get("name")) 

		if not stat is Stat:
			continue
		
		if stat.key in new_map:
			push_warning("Found duplicate key: ", stat.key, " in stats: ", self.owner.name)
			continue

		new_map[stat.key] = stat
	
	#print(new_map)
	return new_map

func get_stats() -> Array:
	return map.values()

func get_stat(key) -> Stat:
	return map[key] if key in map else null

func has_stat(key) -> bool:
	return map.has(key)

func add_stat_modifier(stat_modifier: StatModifier) -> void:
	var stat: Stat = get_stat(stat_modifier.key)

	if stat == null:
		return
	
	stat.add_stat_modifier(stat_modifier)
	
	if stat_modifier.persist_ms == 1:
		await Global.get_tree().physics_frame
		stat.remove_stat_modifier(stat_modifier)
	elif stat_modifier.persist_ms > 0:
		await Global.get_tree().create_timer(stat_modifier.persist_ms).timeout
		stat.remove_stat_modifier(stat_modifier)

func remove_stat_modifier(stat_modifier: StatModifier) -> void:
	var stat: Stat = get_stat(stat_modifier.key)

	if stat == null:
		return
		
	stat.remove_stat_modifier(stat_modifier)

func clear_stat_modifiers() -> void:
	for stat in get_stats():
		stat.clear_stat_modifiers()
