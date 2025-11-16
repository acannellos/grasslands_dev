class_name PlayerCombatState
extends PlayerState

#@export var input: PlayerInput
@export var combat: PlayerCombat

enum States {IDLE, CHARGING, CHARGED, ACTING, COOLDOWN, DEBUG}

var ability: Ability

func _ready():
	ability = player.abilities[0]
	set_state(States.IDLE)

func get_transition():
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
			if Input.is_action_just_released("primary"):
				return States.ACTING

	return States.IDLE

#func enter_state(new_state) -> void:
	#match state:
		#States.ACTING:
			#match ability.combat_type:
				#"hitscan":
					#combat.handle_hitscan()
				#"projectile":
					#combat.handle_projectile()

func state_logic(delta: float) -> void:
	print(state * 10000)
	match state:
		States.ACTING:
			match ability.combat_type:
				"hitscan":
					combat.handle_hitscan()
				"projectile":
					combat.handle_projectile()
