class_name Ability
extends Resource

@export var ability_name: String = "hatsu"
@export_enum("on_press", "on_hold", "on_release") var input_type: String = "on_press"
@export_enum("melee", "hitscan", "projectile") var combat_type: String = "hitscan"
#@export_enum("hitscan", "projectile") var hit_type: String = "hitscan"

#@export_enum("punch", "beam", "wave", "ball") var type: String = "beam"
#@export var is_rapid: bool = false
#@export var can_charge: bool = false

#@export_subgroup("Properties")
@export_range(0.1, 5) var cooldown: float = 0.1  # Firerate
@export_range(1, 200) var max_distance: int = 100  # Fire distance
#@export_range(0, 100) var damage: float = 5  # Damage per hit
#@export_range(0, 100) var damage_min: float = 5  # Damage per hit
#@export_range(0, 100) var damage_max: float = 5  # Damage per hit
#
@export_range(0, 10) var target_spread: float = 0  # Spread of each shot
@export_range(0, 5) var spawn_spread: float = 0  # Spread of each shot
@export_range(1, 10) var shot_count: int = 1  # Amount of shots
@export_range(0, 100) var knockback: int = 0  # Amount of knockback

#@export_subgroup("other")
#@export var sound_shoot: String  # Sound path
#@export var ability_texture: Texture2D
#@export var crosshair: Texture2D  # Image of crosshair on-screen
