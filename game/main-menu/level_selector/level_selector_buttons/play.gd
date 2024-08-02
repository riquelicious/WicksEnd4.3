extends GestureButton

func _fetch_gesture():
	return GlobalControls.lsPlay

func _on_gesture_button_activate():
	Transition.change_scene(FilePaths.levels[Global.level_settings.level_selection])
