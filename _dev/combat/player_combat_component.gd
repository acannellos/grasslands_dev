class_name PlayerCombat
extends CombatComponent

@export var ability_cooldown: Timer
@export var raycast: RayCast3D
@export var marker: Marker3D

@export var projectile: PackedScene
@export var bullet_trail: PackedScene

@onready var player: Player = get_owner()

func use_ability(ability: Ability) -> void:
	match ability.combat_type:
		"melee":
			handle_melee(ability)
		"hitscan":
			handle_hitscan(ability)
		"projectile":
			handle_projectile()
#
#func handle_melee() -> void:
	#Draw.square(marker.global_position, marker.global_basis, Vector3(1, 1, -3), Color.WHITE_SMOKE, 2)


func handle_melee(ability: Ability) -> void:
	# --- Query Setup ---
	var space_state = player.get_world_3d().direct_space_state

	# Define melee hitbox dimensions (matches your Draw.square)
	var box_extents := Vector3(1, 1, 3) * 0.5  # half extents
	var shape := BoxShape3D.new()
	shape.size = box_extents * 2

	# Use the marker’s transform to center the shape in front of player
	var xform := marker.global_transform
	# Move the box forward by half its length so it sits *in front*
	xform.origin += marker.global_basis.z * -box_extents.z

	var query := PhysicsShapeQueryParameters3D.new()
	query.shape = shape
	query.transform = xform
	query.collide_with_areas = true
	query.collide_with_bodies = true

	# --- Query Execution ---
	var hits = space_state.intersect_shape(query, 16)

	var debug_color := Color.WHITE_SMOKE

	if hits.size() > 0:
		var hit_something_damagable := false
		var hit_something_undamagable := false

		for hit in hits:
			var collider = hit["collider"]

			if collider == player:
				continue

			if collider and collider.has_method("damage"):
				# TODO: Replace with your ability damage values
				var dmg := randi_range(ability.damage_min, ability.damage_max)
				collider.damage(dmg)
				hit_something_damagable = true
			else:
				hit_something_undamagable = true

		# Set color based on best match
		if hit_something_damagable:
			debug_color = Color.RED
		elif hit_something_undamagable:
			debug_color = Color.ORANGE
	else:
		debug_color = Color.MAGENTA

	# --- Draw Debug Square ---
	Draw.square(
		marker.global_position,
		marker.global_basis,
		Vector3(0.5, 0.5, -3),
		debug_color,
		2
	)


func handle_projectile():
	var attack = projectile.instantiate()
	get_tree().root.add_child(attack)
	attack.global_transform = marker.global_transform

func handle_hitscan(ability: Ability):
	
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
