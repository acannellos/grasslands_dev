class_name Player
extends CharacterBody3D
#
#@export var data: PlayerData = PlayerData.new()
#@export var abilities: Array[Ability] = []
#
#@export_category("components")
#@export var input: PlayerInput
@export var head: PlayerHead
#@export var pools: PlayerPools
#
#@export_category("states")
#@export var move_state: PlayerMoveState
#@export var grounded_state: PlayerGroundedState
#@export var combat_state: PlayerCombatState
#
#func _ready() -> void:
	#Events.player_connected.emit(self)
	#Events.player_used_slot_data.connect(use_slot_data)
	#Events.player_equip_item_mod.connect(equip_item_mod)
	#Events.player_unequip_item_mod.connect(unequip_item_mod)
	##Global.player = self
#
func _input(event: InputEvent) -> void:
	head.handle_camera_input(event)

#func _physics_process(delta: float) -> void:
	#pools.handle_pools(delta)
	##controller.handle_controller(delta)
	#head.handle_controller_input(delta)
	#head.move_sub_camera()
#
#func use_slot_data(slot_data: ItemSlotData) -> void:
	#slot_data.item_data.use(self)
#
#func equip_item_mod(stat_mod: StatModifier) -> void:
	#data.stats.add_stat_modifier(stat_mod)
#
#func unequip_item_mod(stat_mod: StatModifier) -> void:
	#data.stats.remove_stat_modifier(stat_mod)
