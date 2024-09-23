extends Area2D
class_name CelestialBody

# Whether the mouse is currently over the celestial body.
var mouse_is_over: bool = false

# Whether the mouse button or screen touch is down.
var pressed: bool = false

# The movement of the mouse or screen touch during the last frame.
var movement := Vector2.ZERO

# The position when the body was first clicked
var prev_global_position := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(func() -> void: mouse_is_over = true)
	mouse_exited.connect(func() -> void: mouse_is_over = false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += movement
	movement = Vector2i.ZERO

# Handle user input.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed() and not pressed and mouse_is_over:
				pressed = true
				prev_global_position = global_position
			elif event.is_released() and pressed:
				release()
	elif event is InputEventScreenTouch:
		if event.index == 0:
			if event.is_pressed() and not pressed and mouse_is_over:
				pressed = true
				prev_global_position = global_position
			elif event.is_released() and pressed:
				release()
	elif event is InputEventMouseMotion or event is InputEventScreenDrag:
		drag(event)


func drag(event: InputEvent) -> void:
	if not pressed:
		return
	movement += event.relative

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
