extends Node2D

@onready var sun: CelestialBody = $Sun
@onready var earth: CelestialBody = $Earth
@onready var moon: CelestialBody = $Moon

@onready var sun_orbit: Orbit = $SunOrbit
@onready var earth_orbit: Orbit = $EarthOrbit
@onready var moon_orbit: Orbit = $MoonOrbit

@onready var date_label: Label = $DateLabel

var sun_correct: bool = false
var earth_correct: bool = false
var moon_correct: bool = false

var earth_i = 0
var moon_i = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	sun_orbit.changed.connect(on_orbit_change)
	earth_orbit.changed.connect(on_orbit_change)
	moon_orbit.changed.connect(on_orbit_change)
	
	sun_orbit.set_orbiting_body(moon, sun_orbit.snap_points[0])
	earth_orbit.set_orbiting_body(sun, earth_orbit.snap_points[0])
	moon_orbit.set_orbiting_body(earth, moon_orbit.snap_points[14])

func on_orbit_change(orbit: Orbit, body: CelestialBody, i: int) -> void:
	if body == sun:
		sun_correct = orbit == sun_orbit
	elif body == earth:
		earth_correct = orbit == earth_orbit
		earth_i = i
	elif body == moon:
		moon_correct = orbit == moon_orbit
		moon_i = i
		
	if sun_correct and earth_correct and moon_correct:
		date_label.visible = true
		date_label.text = "2238-%02d-%02d" % [13 - earth_i, 28 - moon_i]
	else:
		date_label.text = "ERR-ERR-ERR"
