class_name PlayerCombatState
extends PlayerState

@export var combat: PlayerCombat

enum States {IDLE, CHARGING, CHARGED, ACTING, COOLDOWN}

var ability: Ability

func _ready():
	ability = player.abilities[0]
	set_state(States.IDLE)

func get_transition():
	match state:
		States.IDLE:
			match ability.input_type:
				"on_press":
					if Input.is_action_just_pressed("primary"):
						return States.ACTING
				"on_hold":
					if Input.is_action_pressed("primary"):
						return States.ACTING
				"on_release":
					if Input.is_action_pressed("primary"):
						return States.CHARGING
					#if Input.is_action_just_released("primary"):
						#return States.ACTING
		
		States.CHARGING:
			if Input.is_action_pressed("primary"):
				return States.CHARGING
			if Input.is_action_just_released("primary"):
				return States.ACTING
		#States.CHARGED:
			#pass
		
		States.ACTING:
			return States.COOLDOWN

		States.COOLDOWN:
			if not combat.ability_cooldown.is_stopped():
				return States.COOLDOWN

	return States.IDLE

func enter_state(new_state) -> void:
	match new_state:
		States.COOLDOWN:
			combat.ability_cooldown.start(ability.cooldown)

func state_logic(delta: float) -> void:
	
	#print(Enums.get_enum_name(States, state))
	
	match state:
		States.ACTING:
			combat.use_ability(ability)
			
			##if ability is Ability:
				##print("ability")
			#
			#match ability.combat_type:
				#"hitscan":
					#combat.handle_hitscan(ability)
				#"projectile":
					#combat.handle_projectile()
