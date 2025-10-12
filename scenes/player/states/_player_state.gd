class_name PlayerState
extends StateMachine

@onready var player: Player = get_owner()
#@onready var _stats: PlayerStats = player.data.stats
@onready var _input: PlayerInput = player.input
@onready var _head: PlayerHead = player.head
#@onready var _pools: PlayerPools = player.pools
