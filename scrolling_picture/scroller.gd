extends Control

# Whether the mouse button or screen touch is down.
var pressed: bool = false

# The movement of the mouse or screen touch during the last frame.
var movement := Vector2.ZERO

# The texture rectangle that actually holds the picture.
@onready var picture: TextureRect = %ScrollingPicture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	picture.add_to_scroll(movement.x)
	movement = Vector2.ZERO

# Handle user input.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed() and not pressed:
				pressed = true
			elif event.is_released() and pressed:
				pressed = false
				movement = Vector2.ZERO
	elif event is InputEventScreenTouch:
		if event.index == 0:
			if event.is_pressed() and not pressed:
				pressed = true
			elif event.is_released() and pressed:
				pressed = false
				movement = Vector2.ZERO
	elif event is InputEventMouseMotion:
		if pressed:
			movement += event.relative
	elif event is InputEventScreenDrag:
		if pressed:
			movement += event.relative
