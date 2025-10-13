@tool
extends Node3D

@export var mesh: MeshInstance3D
@export var col: CollisionShape3D
@export_range(1, 10) var collision_decimation: int = 2

@export_tool_button("create_collision") var _create_collision = create_collision

var heightmap: NoiseTexture2D
var vignette: GradientTexture2D
var hmap_image: Image
var vignette_image: Image
var heightmap_scale: float
var height: float
var float_array: PackedFloat32Array

func _ready() -> void:
	create_collision()

func create_collision() -> void:
	var mat := mesh.get_surface_override_material(0)
	if mat == null:
		push_error("mesh material not found")
		return

	heightmap = mat.get("shader_parameter/heightmap") as NoiseTexture2D
	vignette = mat.get("shader_parameter/vignette") as GradientTexture2D
	height = mat.get("shader_parameter/height")

	await get_tree().process_frame

	hmap_image = heightmap.get_image()
	if vignette:
		vignette_image = vignette.get_image()

	var original_width: int = hmap_image.get_width()
	var original_height: int = hmap_image.get_height()
	
	var decimation: int = max(1, collision_decimation)
	var reduced_width: int = int(ceil(float(original_width) / decimation))
	var reduced_height: int = int(ceil(float(original_height) / decimation))

	float_array.clear()

	for y in range(0, original_height, decimation):
		for x in range(0, original_width, decimation):

			var heightmap_sample: float = hmap_image.get_pixel(x, y).r
			var vignette_sample: float = 1.0
			
			if heightmap.color_ramp:
				heightmap_sample = heightmap.color_ramp.sample(heightmap_sample).srgb_to_linear().r
			
			if vignette:
				vignette.use_hdr = true
				vignette_sample = vignette_image.get_pixel(x, y).r
			
			var final_sample: float = heightmap_sample * vignette_sample * height / collision_decimation
			
			float_array.push_back(final_sample)

	var shape := HeightMapShape3D.new()
	shape.map_width = reduced_width
	shape.map_depth = reduced_height
	shape.map_data = float_array
	col.scale = Vector3.ONE * decimation
	col.shape = shape
