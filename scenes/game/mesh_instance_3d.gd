@tool
extends MeshInstance3D

@export var noise: FastNoiseLite

func _physics_process(delta: float) -> void:
	if noise:
		#noise.offset += Vector3(delta * 100.0, delta * 100.0, 0)
		noise.offset += Vector3(delta * 50.0, delta * 50.0, 0)
