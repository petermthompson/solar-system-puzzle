extends Area2D
class_name CelestialBody

# Whether the mouse button or screen touch is down.
var pressed: bool = false

# The movement of the mouse or screen touch during the last frame.
var movement := Vector2.ZERO

# The position when the body was first clicked
var prev_global_position := Vector2.ZERO

# The collision shape node.
@onready var collision: CollisionShape2D = $CollisionShape2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += movement
	movement = Vector2i.ZERO

# Handle user input.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed() and not pressed:
				press(event.position)
			elif event.is_released() and pressed:
				release()
	elif event is InputEventScreenTouch:
		if event.index == 0:
			if event.is_pressed() and not pressed:
				press(event.position)
			elif event.is_released() and pressed:
				release()
	elif event is InputEventMouseMotion:
		drag(event)


func drag(event: InputEvent) -> void:
	if not pressed:
		return
	movement += event.relative

func press(event_position: Vector2) -> void:
	var global_event_pos: Vector2 = event_position - get_viewport_rect().size / 2.0
	var circle_shape := collision.shape as CircleShape2D
	if is_instance_valid(circle_shape) and global_position.distance_to(global_event_pos) < circle_shape.radius:
		pressed = true
		prev_global_position = global_position

func release() -> void:
	pressed = false
	movement = Vector2.ZERO
	var areas := get_overlapping_areas().filter(func(a) -> bool: return a.get_parent() is Orbit)
	if areas.size() > 0:
		var closest_area: Area2D
		var closest_dis: float = 9999999999
		for area in areas:				
			var dis := global_position.distance_to(area.global_position)
			if not is_instance_valid(closest_area) || dis < closest_dis:
				closest_dis = dis
				closest_area = area
		
		if is_instance_valid(closest_area):
			global_position = closest_area.global_position
			var orbit: Orbit = closest_area.get_parent()
			orbit.set_orbiting_body(self, closest_area)
	else:
		global_position = prev_global_position
