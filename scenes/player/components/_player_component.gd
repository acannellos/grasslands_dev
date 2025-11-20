@abstract
class_name PlayerComponent
extends Node

@onready var player: Player = get_owner()
@onready var _stats: PlayerStats = player.data.stats
#@onready var _input: PlayerInput = player.input
#@onready var _pools: PlayerPools = player.pools
