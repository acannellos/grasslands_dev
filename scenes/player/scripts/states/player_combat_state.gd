class_name PlayerCombatState
extends PlayerState

@export var input: PlayerInput
@export var combat: PlayerCombat

enum States {IDLE, CHARGING, CHARGED, ACTING, COOLDOWN}

var ability: Ability
var ability_index: int = 0

func _ready():
	set_ability(ability_index)
	set_state(States.IDLE)

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
	#Events.player_ability_changed.emit()
	#Audio.play("sounds/weapon_change.ogg")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			ability_index = (ability_index + 1) % player.data.abilities.size()
			set_ability(ability_index)
			print(player.data.abilities[ability_index].ability_name)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			ability_index = (ability_index - 1)
			if ability_index < 0:
				ability_index = player.data.abilities.size() - 1
			set_ability(ability_index)
			print(player.data.abilities[ability_index].ability_name)

#func change_ability() -> void:
	#if Input.is_action_just_pressed("ability_next"):
		#ability_index = (ability_index + 1) % player.data.abilities.size()
		#set_ability(ability_index)
	#
	#if Input.is_action_just_pressed("ability_prev"):
		#ability_index = (ability_index - 1)
		#if ability_index < 0:
			#ability_index = player.data.abilities.size() - 1
		#set_ability(ability_index)
