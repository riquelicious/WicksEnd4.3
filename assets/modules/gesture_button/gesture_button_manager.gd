class_name GestureButtonManager
extends Node

var parent : Node
var previous_gesture
var fetched_gesture
var gesture_cooldown : float = 0.0
var gesture_delay : float = 0.3
var gesture_icon : TextureRect

func initialize(parent_instance : Node):
	parent = parent_instance
	gesture_icon = parent.find_child("button_gesture_icon")
	fetch_gesture()
	change_gesture_image()

func fetch_gesture() -> void:
	if parent.button_gesture:
		fetched_gesture = parent.button_gesture
	elif parent.button_fallback_gesture != 0:
		fetched_gesture = Global.gesture_settings.gesture_list[parent.button_fallback_gesture]
	
func check_gesture(delta):
	var gesture = Global.gesture_settings.gesture
	if gesture == Global.gesture_settings.gesture_list[0]:
		gesture_cooldown += delta
		if gesture_cooldown != gesture_delay:
			return
	gesture_cooldown = 0.0
	previous_gesture = gesture
	return previous_gesture

func update_button_state(delta):
	var gesture = check_gesture(delta)
	if gesture:
		if gesture == fetched_gesture:
			parent.gesture_button_animation_manager.fade_in()
		else:
			if parent.gesture_button_animation_manager.button_anim.is_playing():
				if parent.gesture_button_animation_manager.current_anim != "clicked":
					parent.gesture_button_animation_manager.fade_out()

func change_gesture_image():
	var gesture_index = Global.gesture_settings.gesture_list.find(fetched_gesture)
	gesture_icon.texture = FilePaths.gesture_icons[gesture_index]

		
