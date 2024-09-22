shader_type canvas_item;

// The scroll amount in pixels.
uniform float scroll = 0;

// The original size of the picture that is being displayed.
uniform vec2 picture_size;

// The size of the rectangle that the picture is being displayed on.
uniform vec2 rectangle_size;

void fragment() {
	vec2 coords = UV * rectangle_size;
	float height_scale = rectangle_size.y / picture_size.y;
	vec2 scaled_picture_size = height_scale * picture_size;
	coords.x = mod(coords.x - scroll, scaled_picture_size.x);
	COLOR = texture(TEXTURE, coords / scaled_picture_size);
}
