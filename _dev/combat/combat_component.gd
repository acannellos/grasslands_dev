class_name CombatComponent
extends Node

signal ability_used

@export var ability_cooldown: Timer
@export var raycast: RayCast3D
@export var marker: Marker3D

var ability: Ability
@export var abilities: Array[Ability] = []
var _cooldowns := []

func _ready():
	_cooldowns.resize(abilities.size())
	for i in _cooldowns.size():
		_cooldowns[i] = 0.0

func _process(delta):
	for i in range(_cooldowns.size()):
		if _cooldowns[i] > 0.0:
			_cooldowns[i] = max(0.0, _cooldowns[i] - delta)

func can_use_ability(idx: int) -> bool:
	if idx < 0 or idx >= abilities.size():
		return false
	return _cooldowns[idx] == 0.0

func use_ability(idx: int, target: Node, context: Dictionary = {}) -> bool:
	if not can_use_ability(idx):
		return false
	var ability = abilities[idx]

	# Prepare context (include user stats, etc.)
	context["user"] = self
	var action = ability.execute(self, target, context)
	_apply_action(action)
	_cooldowns[idx] = ability.cooldown
	emit_signal("ability_used", action)
	return true

func _apply_action(action: Dictionary) -> void:
	# Damage application
	if action.has("is_aoe") and action["is_aoe"]:
		# Do area damage (simple example)
		var aoe_radius = action.get("aoe_radius", 64.0)
		var center = action.get("target").position if action.get("target") else action["source"].position
		var bodies = get_tree().get_nodes_in_group("combatants") # or use physics queries
		for b in bodies:
			if b.position.distance_to(center) <= aoe_radius:
				if b != self:
					b.apply_damage(action["damage"])
	else:
		var tgt = action.get("target")
		if tgt:
			tgt.apply_damage(action["damage"])
	# Spawn VFX or sfx is handled by listeners (presentation)

#func apply_damage(amount: float) -> void:
	#health -= amount
	#if health <= 0:
		#die()

func die() -> void:
	queue_free() # or a death routine
