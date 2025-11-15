class_name PlayerCombatState
extends PlayerState

@export var input: PlayerInput

enum States {IDLE, RUNNING, SPRINTING, SLIDING, DODGING, DEBUG}

func _ready():
	set_state(States.IDLE)
