class_name PlayerAbilityComponent
extends PlayerComponent

@export var head: Node3D
@export var raycast: RayCast3D
@export var marker: Marker3D
@export var ability_cooldown: Timer
#@export var test_particle: PackedScene

var ability: Ability
var ability_index: int = 0
var debug_ribbon_life: int = 2
var is_charging: bool = false

var og_rot: Basis
var t: float = 0.001
var charge_time: float = 0.0

func _ready():
	await get_tree().physics_frame
	set_ability(ability_index)
	og_rot = marker.basis
	#Events.ren_activated.connect(_on_ren_activated)
	#Events.ren_deactivated.connect(_on_ren_deactivated)

func _physics_process(delta: float) -> void:
	if is_charging:
		t = lerp(t, 0.1, delta * 0.5)
		#marker.rotate_z(t * TAU)
		charge_time += delta
		charge_time = clamp(charge_time, charge_time, 3)
	else:
		#marker.basis = lerp(marker.basis, og_rot, delta * 2)
		t = 0.001
		charge_time = 0.0
	
	change_ability()
	
	#if _pools.aura.value > 1 and _pools.output.value < _pools.output.max_stat.value - 1:
		#use_ability()
	
	use_ability()


var nen_multiplier: float = 1.0

#func _on_ren_activated(ren_color: Color) -> void:
	#nen_multiplier = 1.4
#
#func _on_ren_deactivated() -> void:
	#nen_multiplier = 1.0

@export var shape_cast_helper: PackedScene
@export var anim_player: AnimationPlayer

func set_ability(index: int) -> void:
	ability = player.abilities[index]
	Events.player_ability_changed.emit()
	#Audio.play("sounds/weapon_change.ogg")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			ability_index = (ability_index + 1) % player.abilities.size()
			set_ability(ability_index)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			ability_index = (ability_index - 1)
			if ability_index < 0:
				ability_index = player.abilities.size() - 1
			set_ability(ability_index)

func change_ability() -> void:
	if Input.is_action_just_pressed("ability_next"):
		ability_index = (ability_index + 1) % player.abilities.size()
		set_ability(ability_index)
	
	if Input.is_action_just_pressed("ability_prev"):
		ability_index = (ability_index - 1)
		if ability_index < 0:
			ability_index = player.abilities.size() - 1
		set_ability(ability_index)



@export var projectile: PackedScene



func use_ability():
	match ability.input:
		"rapid_fire":
			if Input.is_action_pressed("primary"):
				match ability.hit_type:
					"hitscan":
						handle_hitscan()
					"projectile":
						handle_projectile()
				
				#_pools.aura.update(-1)
				#_pools.output.update(1)
		"single_fire":
			if Input.is_action_just_pressed("primary"):
				match ability.hit_type:
					"hitscan":
						handle_hitscan()
					"projectile":
						handle_projectile()
				#_pools.aura.update(-2)
				#_pools.output.update(2)
		"hold_and_release":
			if Input.is_action_pressed("primary"):
				is_charging = true
			if Input.is_action_just_released("primary"):
				match ability.hit_type:
					"hitscan":
						handle_hitscan()
					"projectile":
						handle_projectile()
				is_charging = false
				#_pools.aura.update(-2)
				#_pools.output.update(2)
	
	#if Input.is_action_just_pressed("secondary"):
		#Events.ren_activated.emit(ren_color)
		#player.velocity.y = 0
		#
	#if Input.is_action_just_released("secondary"):
		#Events.ren_deactivated.emit()

func emit_ability():
	
	#_pools.aura.update(-2)
	#_pools.output.update(2)
	handle_hitscan()
	
func handle_projectile():
	if not ability_cooldown.is_stopped(): return
	ability_cooldown.start(ability.cooldown)
	
	anim_player.play("pistol_shoot")
	
	#var attack = projectile.instantiate() as RayCast3D
	var attack = projectile.instantiate()
	add_child(attack)
	attack.global_transform = marker.global_transform
	
func handle_hitscan():
	if not ability_cooldown.is_stopped(): return
	ability_cooldown.start(ability.cooldown)
	
	anim_player.play("pistol_shoot")
	
	raycast.target_position.z = -ability.max_distance
	
	#Audio.play(ability.sound_shoot)
	
	for n in ability.shot_count:
		
		raycast.target_position.x = randf_range(-ability.target_spread, ability.target_spread)
		raycast.target_position.y = randf_range(-ability.target_spread, ability.target_spread)
		
		raycast.force_raycast_update()
		
		var collider = raycast.get_collider()
		
		var end_pos: Vector3 = Vector3.FORWARD
		var selected_color: Color = Color.WHITE
		if raycast.is_colliding():
			end_pos = raycast.get_collision_point()
			
			# HACK removed the particle stuff for now
			
			#var normal = raycast.get_collision_normal()

			#var particle_hit = test_particle.instantiate()
			#get_tree().root.add_child(particle_hit)
#
			#particle_hit.global_position = end_pos
#
			#var target_point = end_pos + normal
			#particle_hit.look_at(target_point, Vector3.UP)
#
			#particle_hit.emitting = true
			
			
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
		
		if is_charging:
			var base_radius = 1.0 * charge_time
			var color_new: Color = selected_color * Color(1, 1, 1, 0.2)
			Draw.point(end_pos, base_radius, color_new, debug_ribbon_life)
			var shape: ShapeCast3D = shape_cast_helper.instantiate()
			shape.shape = SphereShape3D.new()
			shape.shape.radius = base_radius
			get_tree().root.add_child(shape)
			shape.global_position = end_pos
			shape.force_shapecast_update()
			
			for col in shape.get_collision_count():
				var next_collider = shape.get_collider(col)
	
				if shape.is_colliding():
					if next_collider.has_method("damage"):
						var dmg = randi_range(ability.damage_min, ability.damage_max)
						dmg = round(dmg * nen_multiplier)
						next_collider.damage(dmg)
		
		var spawn_rand: float = randf_range(-ability.spawn_spread, ability.spawn_spread)
		var spawn_pos: Vector3 = marker.global_position + Vector3.ONE * spawn_rand
		
		#Draw.line(spawn_pos, end_pos, selected_color, debug_ribbon_life)
		Draw.line_as_vertical_ribbon(spawn_pos, end_pos, selected_color, 0.1, debug_ribbon_life)
		
		var kb: Vector3 = raycast.global_basis.z.normalized() * ability.knockback
		kb = Vector3(kb.x, kb.y * 0.2, kb.z)
		player.velocity += kb
		Draw.line(spawn_pos, spawn_pos + kb, Color.GREEN_YELLOW, debug_ribbon_life)
		
		#head.sway_z(ability.knockback * 100)
