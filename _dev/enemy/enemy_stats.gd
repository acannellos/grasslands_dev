class_name EnemyStats
extends Stats

@export var max_health: IntStat = IntStat.new(20, Enums.IntStatType.MAX_HEALTH)
@export var health_regen: IntStat = IntStat.new(0, Enums.IntStatType.HEALTH_REGEN)
