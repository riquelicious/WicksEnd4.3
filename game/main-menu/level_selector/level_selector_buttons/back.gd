extends GestureButton

@export var main_menu : Node3D

func _fetch_gesture():
	return GlobalControls.lsBack

func _on_gesture_button_activate():
	main_menu.on_back_button_clicked()
