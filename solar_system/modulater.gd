extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if JavaScriptBridge.eval("navigator.userAgent.match(/Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile/i)"):
		modulate = Color.WHITE
	else:
		modulate = Color.WEB_GRAY
