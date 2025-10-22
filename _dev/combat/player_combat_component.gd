class_name PlayerCombatComponent
extends CombatComponent

@onready var player: Player = get_owner()

func _ready():
	ability = abilities[0]

func _physics_process(delta: float) -> void:
	player_use_ability()


func player_use_ability():
	match ability.input:
		"on_hold":
			if Input.is_action_pressed("primary"):
				match ability.hit_type:
					"hitscan":
						handle_hitscan()
					#"projectile":
						#handle_projectile()
				
				#_pools.aura.update(-1)
				#_pools.output.update(1)
		"on_press":
			if Input.is_action_just_pressed("primary"):
				match ability.hit_type:
					"hitscan":
						handle_hitscan()
					#"projectile":
						#handle_projectile()
				#_pools.aura.update(-2)
				#_pools.output.update(2)
		"on_release":
			#if Input.is_action_pressed("primary"):
				#is_charging = true
			if Input.is_action_just_released("primary"):
				match ability.hit_type:
					"hitscan":
						handle_hitscan()
					#"projectile":
						#handle_projectile()
				#is_charging = false


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
		
		var kb: Vector3 = raycast.global_basis.z.normalized() * ability.knockback
		kb = Vector3(kb.x, kb.y * 0.2, kb.z)
		player.velocity += kb
		Draw.line(spawn_pos, spawn_pos + kb, Color.GREEN_YELLOW, 2)
		
		#head.sway_z(ability.knockback * 100)
