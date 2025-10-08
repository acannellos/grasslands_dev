@tool
extends Node3D

@export var grid: MeshInstance3D
@export var col: CollisionShape3D
@export var collision_decimation := 2
@export_tool_button("create_collision") var _create_collision = create_collision

var float_array: PackedFloat32Array

var heightmap: NoiseTexture2D
var vignette: GradientTexture2D
var hmap_image: Image
var vignette_image: Image
var heightmap_scale: float
var height: float

func _ready() -> void:
	create_collision()

func create_collision() -> void:
	var mat := grid.get_surface_override_material(0)
	if mat == null:
		push_error("Grid material not found.")
		return

	heightmap = mat.get("shader_parameter/heightmap") as NoiseTexture2D
	vignette = mat.get("shader_parameter/vignette") as GradientTexture2D
	height = mat.get("shader_parameter/height")
	heightmap_scale = mat.get("shader_parameter/heightmap_scale")

	await get_tree().process_frame

	hmap_image = heightmap.get_image()
	if vignette:
		vignette_image = vignette.get_image()

	var original_width = hmap_image.get_width()
	var original_height = hmap_image.get_height()
	var decimated_width = original_width / collision_decimation
	var decimated_height = original_height / collision_decimation

	float_array.clear()

	for y in range(decimated_height):
		for x in range(decimated_width):
			var sample_x := x * collision_decimation
			var sample_y := y * collision_decimation

			var heightmap_sample := hmap_image.get_pixel(sample_x, sample_y).r
			
			var final_sample := heightmap_sample * height

			# Vignette sample if available (same coordinate scaling)
			if vignette_image:
				var vignette_sample = vignette_image.get_pixel(sample_x, sample_y).r
				final_sample *= vignette_sample

			float_array.push_back(final_sample)

	# Build and assign HeightMapShape3D
	var shape := HeightMapShape3D.new()
	shape.map_width = decimated_width
	shape.map_depth = decimated_height
	shape.map_data = float_array
	col.shape = shape

	col.scale.x = grid.scale.x * collision_decimation * heightmap_scale
	col.scale.z = grid.scale.z * collision_decimation * heightmap_scale
	
	#Events.heightmap_finished.emit()


#
#extends Node3D
#
#@export var grid: MeshInstance3D
#@export var col: CollisionShape3D
#@export var collision_decimation := 2
#
#var heightmap: NoiseTexture2D
#var hmap_image: Image
#var heightmap_scale: float
#var height: float
#var vignette_radius: float
#var vignette_intensity: float
#
#var float_array: PackedFloat32Array
#
#func _ready() -> void:
	#create_collision()
#
#func create_collision() -> void:
	## Fetch the shader uniforms from the material
	#var mat := grid.get_surface_override_material(0)
	#heightmap = mat.get("shader_parameter/heightmap") as NoiseTexture2D
	#height = mat.get("shader_parameter/height")
	#heightmap_scale = mat.get("shader_parameter/heightmap_scale")
	#vignette_radius = mat.get("shader_parameter/vignette_radius")
	#vignette_intensity = mat.get("shader_parameter/vignette_intensity")
#
	#await get_tree().process_frame
	#hmap_image = heightmap.get_image()
#
	#var original_width = hmap_image.get_width()
	#var original_height = hmap_image.get_height()
	#var decimated_width = original_width / collision_decimation
	#var decimated_height = original_height / collision_decimation
#
	#float_array.clear()
#
	## Calculate heights with vignette effect applied
	#for y in range(decimated_height):
		#for x in range(decimated_width):
			#var sample_x = x * collision_decimation
			#var sample_y = y * collision_decimation
			#var height := hmap_image.get_pixel(sample_x, sample_y).r
#
			## Compute vignette factor for this pixel
			#var uv_x: float = float(sample_x) / original_width
			#var uv_y: float = float(sample_y) / original_height
			#var centered_uv := Vector2(uv_x, uv_y) - Vector2(0.5, 0.5)
			#var dist := centered_uv.length()
			#var vignette := smoothstep(vignette_radius, 1.0, 1.0 - dist)
			#var vignette_factor: float = lerp(1.0 - vignette_intensity, 1.0, vignette)
#
			## Apply vignette to the height
			#var final_height := height * height * vignette_factor
			#float_array.push_back(final_height)
#
	## Build the collision shape
	#var shape := HeightMapShape3D.new()
	#shape.map_width = decimated_width
	#shape.map_depth = decimated_height
	#shape.map_data = float_array
	#col.shape = shape
#
	## Apply correct scale
	#col.scale.x = grid.scale.x * collision_decimation * heightmap_scale
	#col.scale.z = grid.scale.z * collision_decimation * heightmap_scale
