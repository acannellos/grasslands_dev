class_name Enums

static func get_enum_name(e, i) -> String: return e.keys()[i]

enum FloatStatType {
	SPEED,
	ACCELERATION,
	GRAVITY,
	JUMP_HEIGHT,
	DODGE_RANGE,
	DODGE_COOLDOWN,
}

enum IntStatType {
	AIR_JUMPS,
	MAX_HEALTH,
	MAX_AURA,
	MAX_OUTPUT,
	HEALTH_REGEN,
	AURA_REGEN,
	OUTPUT_REGEN,
	DODGE_COUNT,
	ITEM_SLOTS,
}

enum BoolStatType {
	CAN_MOVE,
	CAN_DODGE,
}

enum StatModType {
	FLAT,
	MULTI_A,
	MULTI_M,
}
