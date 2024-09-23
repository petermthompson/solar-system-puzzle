extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var console = JavaScriptBridge.get_interface("console")
	console.log("Test")
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		modulate = Color.WHITE
		console.log("low-end gpu")
	else:
		modulate = Color.WEB_GRAY
		console.log("high-end gpu")
