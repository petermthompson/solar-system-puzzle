@tool
extends TextureRect

# The scroll amount in pixels.
var scroll: float = 0.0

# The original size of the picture that is being displayed.
var picture_size := Vector2.ZERO

# The size of the rectangle that the picture is being displayed on.
var rectangle_size := Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Maybe update picture size
	var temp: Vector2 = texture.get_size()
	if picture_size != temp:
		picture_size = temp
		if material is ShaderMaterial:
			material.set_shader_parameter("picture_size", picture_size)
	# Maybe update rectangle size
	if rectangle_size != size:
		rectangle_size = size
		if material is ShaderMaterial:
			material.set_shader_parameter("rectangle_size", rectangle_size)

# Adds a certain number of pixels to the scroll amount.
func add_to_scroll(scroll_change: float) -> void:
	scroll += scroll_change
	if material is ShaderMaterial:
		material.set_shader_parameter("scroll", scroll)
