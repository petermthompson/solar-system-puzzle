shader_type canvas_item;
render_mode unshaded;

// Local uniforms

uniform bool is_earth = true;

// Global uniforms

global uniform vec2 sun_position;
global uniform float sun_radius;

global uniform vec2 earth_position;
global uniform float earth_radius;

global uniform vec2 moon_position;
global uniform float moon_radius;

// Constants

const float FADE_START = 11.0 * PI / 24.0;
const float FADE_END = 13.0 * PI / 24.0;

const float DARK_MULT = 0.25;
const float LIGHT_MULT = 2.0;

// Varyings

varying vec2 my_position;
varying float my_radius;

varying vec2 other_position;
varying float other_radius;

// User functions

// Scales and translates a value as described by the following graphic:
//
//      /--40%-\ /----60%---\
//  <--|--------|------------|-->
//   in_min   in_val       in_max
//
//       /----40%---\ /-------60%------\
//  <---|------------|------------------|--->
//   out_min      out_val            out_max
//
float remap(float in_val, float in_min, float in_max, float out_min, float out_max)
{
	float scale = (out_max - out_min) / (in_max - in_min);
	float out_val = scale * (in_val - in_min) + out_min;
	return out_val;
}

// Get the angle between two vectors u and v
float angle(vec3 u, vec3 v)
{
	// Basic calculation
	float dot_product = dot(u, v);
	float theta = acos(dot_product / (length(u) * length(v)));
	// Handle edge cases
	if (isnan(theta)) {
		if (dot_product > 0.0)
			theta = 0.0;
		else
			theta = PI;
	}
	// Return final result
	return theta;
}

// Returns the vector result of vector a projected onto vector b (perpendicular to b)
vec3 vector_project(vec3 a, vec3 b)
{
	vec3 b_unit = b / length(b);
	return dot(a, b_unit) * b_unit;
}

// Returns the scalar result of vector a projected onto vector b (perpendicular to b)
float scalar_project(vec3 a, vec3 b)
{
	return dot(a, b) / length(b);
}

// Built-in functions

void vertex() {
	if (is_earth) {
		my_position = earth_position;
		my_radius = earth_radius;
		other_position = moon_position;
		other_radius = moon_radius;
	} else {
		my_position = moon_position;
		my_radius = moon_radius;
		other_position = earth_position;
		other_radius = earth_radius;
	}
}

void fragment() {
	// Figure out lighting
	vec2 to_sun = normalize(sun_position - my_position);
	float theta = angle(vec3(to_sun, 0.0), NORMAL);
	// Light side
	if (theta < FADE_START) {
		COLOR.rgb *= LIGHT_MULT;
	// Dark side
	} else if (theta > FADE_END){
		COLOR.rgb *= DARK_MULT;
	// In between
	} else {
		COLOR.rgb *= remap(theta, FADE_START, FADE_END, LIGHT_MULT, DARK_MULT);
	}
}
