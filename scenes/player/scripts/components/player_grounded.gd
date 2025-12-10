class_name PlayerGrounded
extends PlayerComponent

@export var coyote_timer: Timer
@export var jump_buffer_timer: Timer
@export var bunny_hop_timer: Timer

var air_acceleration_mod: FloatStatModifier = FloatStatModifier.new(0.5, Enums.StatModType.MULTI_M, Enums.FloatStatType.ACCELERATION)
#var bunny_hop_speed_mod: FloatStatModifier

var jump_phase: int = 0

#var max_bunny_hops: int = 3
#var bunny_hop_count: int = 0

#func _ready() -> void:
	#bunny_hop_timer.timeout.connect(_on_bunny_hop_timer_timeout)

#func _physics_process(delta: float) -> void:
	#print(_stats.speed.value)
	#print(_stats.acceleration.value)

func handle_gravity(delta: float) -> void:
	player.velocity.y -= _stats.gravity.value * delta

func enter_grounded() -> void:
	jump_phase = _stats.air_jumps.value
	bunny_hop_timer.start()

func enter_air() -> void:
	_stats.add_stat_modifier(air_acceleration_mod)

func exit_air() -> void:
	_stats.remove_stat_modifier(air_acceleration_mod)

func handle_jump() -> void:
	player.velocity.y = 8.0
	jump_buffer_timer.stop()
	
	#bunny_hop_timer.stop()
	#add_bunny_hop_mods()
	#
	#if bunny_hop_count < max_bunny_hops:
		#bunny_hop_count += 1

func use_air_jump() -> void:
	jump_phase -= 1

func can_use_jump_buffer() -> bool:
	return not jump_buffer_timer.is_stopped()

func can_air_jump() -> bool:
	return jump_phase > 0
#
#func _on_bunny_hop_timer_timeout() -> void:
	#if bunny_hop_speed_mod:
		#remove_bunny_hop_mods()
	#
	#bunny_hop_count = 0
#
#func add_bunny_hop_mods() -> void:
#
	#if bunny_hop_speed_mod:
		#remove_bunny_hop_mods()
	#
	#bunny_hop_speed_mod = FloatStatModifier.new(bunny_hop_count * 10, Enums.StatModType.FLAT, Enums.FloatStatType.SPEED)
	#
	#if bunny_hop_count > 0:
		#_stats.add_stat_modifier(bunny_hop_speed_mod)
##
#func remove_bunny_hop_mods() -> void:
	#_stats.remove_stat_modifier(bunny_hop_speed_mod)
