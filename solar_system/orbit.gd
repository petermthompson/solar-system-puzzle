extends Node2D
class_name Orbit

@export var radius: float
@export var num_points: int
@export var suborbit: Orbit

var orbiting_body: CelestialBody

var snap_points: Array[Area2D]

signal changed(orbit: Orbit, body: CelestialBody, index: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, num_points):
		var snap := Area2D.new()
		snap_points.append(snap)
		add_child(snap)
		var theta := i * 2 * PI / num_points
		snap.position = radius * Vector2(cos(theta), sin(theta))
		var col := CollisionShape2D.new()
		snap.add_child(col)
		col.shape = CircleShape2D.new()
		col.shape.radius = radius * PI / num_points


func _draw():
	draw_circle(Vector2.ZERO, radius, Color.WHITE, false, 2.0, true)
	for snap in snap_points:
		draw_circle(snap.position, 4.0, Color.WHITE)

func set_orbiting_body(body: CelestialBody, snap: Area2D):
	assert(snap.get_parent() == self, "Area2D snap is not a child of " + self.to_string())
	
	if is_instance_valid(orbiting_body):
		var swap_snap: Area2D = body.get_parent()
		var swap_orbit: Orbit = swap_snap.get_parent()
		self.orbiting_body.reparent(swap_snap)
		self.orbiting_body.position = Vector2.ZERO
		swap_orbit.orbiting_body = self.orbiting_body
		changed.emit(swap_orbit, swap_orbit.orbiting_body, swap_orbit.snap_points.find(swap_snap))
	body.reparent(snap)
	body.position = Vector2.ZERO
	self.orbiting_body = body
	
	if is_instance_valid(suborbit):
		suborbit.reparent(snap)
		suborbit.position = Vector2.ZERO
	
	changed.emit(self, body, snap_points.find(snap))
