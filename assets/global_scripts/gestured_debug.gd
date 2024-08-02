extends Node

var debug_mouse_key : bool = false
var last_Input_event : InputEvent = null


@onready var prev_mouse_pos : Vector2 = get_viewport().get_mouse_position()

func _input(event):
	last_Input_event = event
	if event is InputEventKey and event.is_pressed():
		if event.keycode >= 48 and event.keycode <= (48 + (len(Global.gesture_settings.gesture_list)-1)):
			Global.gesture_settings.gesture = Global.gesture_settings.gesture_list[event.keycode - 48]
	elif event is InputEventKey and event.is_released():
		if event.keycode >= 48 and event.keycode <= (48 + (len(Global.gesture_settings.gesture_list)-1)):
			Global.gesture_settings.gesture = Global.gesture_settings.gesture[0]

	if debug_mouse_key:
		if event is InputEventKey:
			print(event.keycode)
