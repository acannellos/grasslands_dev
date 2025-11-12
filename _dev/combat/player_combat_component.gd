class_name PlayerCombat
extends CombatComponent

@onready var player: Player = get_owner()

@export var projectile: PackedScene
@export var bullet_trail: PackedScene

func _ready():
	ability = abilities[0]

func _physics_process(delta: float) -> void:
	player_use_ability()


func player_use_ability():
	match ability.input_type:
		"on_hold":
			if Input.is_action_pressed("primary"):
				match ability.combat_type:
					"hitscan":
						handle_hitscan()
					"projectile":
						handle_projectile()
				
				#_pools.aura.update(-1)
				#_pools.output.update(1)
		"on_press":
			if Input.is_action_just_pressed("primary"):
				match ability.combat_type:
					"hitscan":
						handle_hitscan()
					"projectile":
						handle_projectile()
				#_pools.aura.update(-2)
				#_pools.output.update(2)
		"on_release":
			#if Input.is_action_pressed("primary"):
				#is_charging = true
			if Input.is_action_just_released("primary"):
				match ability.combat_type:
					"hitscan":
						handle_hitscan()
					"projectile":
						handle_projectile()
				#is_charging = false


func handle_projectile():
	if not ability_cooldown.is_stopped(): return
	ability_cooldown.start(ability.cooldown)
	
	#anim_player.play("pistol_shoot")
	
	#var attack = projectile.instantiate() as RayCast3D
	var attack = projectile.instantiate()
	#add_child(attack)
	get_tree().root.add_child(attack)
	attack.global_transform = marker.global_transform

func handle_hitscan():
	
	
	if not ability_cooldown.is_stopped(): return
	ability_cooldown.start(ability.cooldown)
	
	raycast.target_position.z = -ability.max_distance
	
	
	for n in ability.shot_count:
		
		raycast.target_position.x = randf_range(-ability.target_spread, ability.target_spread)
		raycast.target_position.y = randf_range(-ability.target_spread, ability.target_spread)
		
		raycast.force_raycast_update()
		
		var collider = raycast.get_collider()
		
		var end_pos: Vector3 = Vector3.FORWARD
		var selected_color: Color = Color.WHITE
		if raycast.is_colliding():
			end_pos = raycast.get_collision_point()
			
			if collider.has_method("damage"):
				var dmg = randi_range(ability.damage_min, ability.damage_max)
				#dmg = round(dmg * nen_multiplier)
				collider.damage(dmg)
				selected_color = Color.RED
			else:
				selected_color = Color.ORANGE
		else:
			end_pos = raycast.to_global(raycast.target_position)
			selected_color = Color.MAGENTA
		
		var spawn_rand: float = randf_range(-ability.spawn_spread, ability.spawn_spread)
		var spawn_pos: Vector3 = marker.global_position + Vector3.ONE * spawn_rand
		
		#Draw.line(spawn_pos, end_pos, selected_color, debug_life)
		Draw.line_as_vertical_ribbon(spawn_pos, end_pos, selected_color, 0.1, 2)
		
		
		# TODO move trail to better spot
		#var _trail = bullet_trail.instantiate()
		#get_tree().root.add_child(_trail)
		#_trail.global_position = spawn_pos
		
		
		var kb: Vector3 = raycast.global_basis.z.normalized() * ability.knockback
		kb = Vector3(kb.x, kb.y * 0.2, kb.z)
		player.velocity += kb
		Draw.line(spawn_pos, spawn_pos + kb, Color.GREEN_YELLOW, 2)
		
		#await get_tree().physics_frame
		#_trail.global_position = end_pos
		
		#head.sway_z(ability.knockback * 100)
