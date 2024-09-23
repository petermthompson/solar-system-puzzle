extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		modulate = Color.WHITE
		JavaScriptBridge.eval("console.log(\'low-end gpu\')")
	else:
		modulate = Color.WEB_GRAY
		JavaScriptBridge.eval("console.log(\'high-end gpu\')")
