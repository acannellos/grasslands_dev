class_name PlayerCombatState
extends PlayerState

@export var input: PlayerInput
@export var combat: PlayerCombat

enum States {IDLE, CHARGING, CHARGED, ACTING, COOLDOWN}

var ability: Ability

func _ready():
	set_ability(0)
	set_state(States.IDLE)
	Events.player_ability_changed.connect(set_ability)

func get_transition():
	match state:
		States.IDLE:
			match ability.input_type:
				"on_press":
					if input.is_primary_just_pressed:
						return States.ACTING
				"on_hold":
					if input.is_primary_pressed:
						return States.ACTING
				"on_release":
					if input.is_primary_pressed:
						return States.CHARGING
		
		States.CHARGING:
			if Input.is_action_pressed("primary"):
				return States.CHARGING
			if input.is_primary_just_released:
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

func set_ability(index: int) -> void:
	ability = player.data.abilities[index]
	print(player.data.abilities[index].ability_name)
	#Audio.play("sounds/weapon_change.ogg")
