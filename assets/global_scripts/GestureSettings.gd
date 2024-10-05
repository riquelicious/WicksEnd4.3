extends Node
class_name GestureSettings

# Gestures
var gesture: String = "None"

var gesture_list: Array = [
	"None", # 0
	"Closed_Fist", # 1
	"Open_Palm", # 2
	"Pointing_Up", # 3
	"Thumb_Down", # 4
	"Thumb_Up", # 5
	"Victory", # 6
	"ILoveYou" # 7
]

var current_gesture: int = 0

func update_gesture(new_gesture: String) -> void:
	current_gesture = gesture_list.find(new_gesture)


func is_gesture_matching(gesture_index: int) -> bool:
	return current_gesture == gesture_index

func get_index_from(control_list: Array):
	return control_list.find(current_gesture)