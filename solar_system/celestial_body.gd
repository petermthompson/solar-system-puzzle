extends Area2D

# Whether the mouse is currently over the celestial body.
var mouse_is_over: bool = false

# Whether the mouse button or screen touch is down.
var pressed: bool = false

# The movement of the mouse or screen touch during the last frame.
var movement := Vector2.ZERO

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
			elif event.is_released() and pressed:
				pressed = false
				movement = Vector2.ZERO
	elif event is InputEventScreenTouch:
		if event.index == 0:
			if event.is_pressed() and not pressed and mouse_is_over:
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
