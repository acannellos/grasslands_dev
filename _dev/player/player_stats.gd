class_name PlayerStats
extends Stats

@export_group("pools")
@export var max_health: IntStat = IntStat.new(10, Enums.IntStatType.MAX_HEALTH)
@export var health_regen: IntStat = IntStat.new(0, Enums.IntStatType.HEALTH_REGEN)

@export var max_aura: IntStat = IntStat.new(40, Enums.IntStatType.MAX_AURA)
@export var aura_regen: IntStat = IntStat.new(0, Enums.IntStatType.AURA_REGEN)

#@export var max_output: IntStat = IntStat.new(10, Enums.IntStatType.MAX_OUTPUT)
#@export var output_regen: IntStat = IntStat.new(0, Enums.IntStatType.OUTPUT_REGEN)

@export_group("controller")
@export var can_move: BoolStat = BoolStat.new(true, Enums.BoolStatType.CAN_MOVE)
@export var speed: FloatStat = FloatStat.new(16.0, Enums.FloatStatType.SPEED)
@export var acceleration: FloatStat = FloatStat.new(0.25, Enums.FloatStatType.ACCELERATION)

@export_group("grounded")
@export var gravity: FloatStat = FloatStat.new(20.0, Enums.FloatStatType.GRAVITY)
@export var jump_height: FloatStat = FloatStat.new(8.0, Enums.FloatStatType.JUMP_HEIGHT)
@export var air_jumps: IntStat = IntStat.new(1, Enums.IntStatType.AIR_JUMPS)

#@export_group("sprint")
#@export var sprint_multi: FloatStat = FloatStat.new(2.0, Enums.FloatStatType.SPRINT_MULTI)

@export_group("dodge")
@export var can_dodge: BoolStat = BoolStat.new(true, Enums.BoolStatType.CAN_DODGE)
@export var dodge_range: FloatStat = FloatStat.new(10.0, Enums.FloatStatType.DODGE_RANGE)
@export var dodge_cooldown: FloatStat = FloatStat.new(1.0, Enums.FloatStatType.DODGE_COOLDOWN)
@export var dodge_count: IntStat = IntStat.new(1, Enums.IntStatType.DODGE_COUNT)

@export_group("inventory")
@export var item_slots: IntStat = IntStat.new(12, Enums.IntStatType.ITEM_SLOTS)
