extends GestureButton

@export var parent : CanvasLayer

var value

func _ready():
	super()
	gesture_label.resized.connect(_change_size)

func _fetch_gesture():
	return GlobalControls.dlControls[1]

func _on_gesture_button_activate():
	print(parent)
	if parent:
		parent.change_value(value)
	else:
		push_error("No parent given")

func _change_size():
	anim.play("RESET")
