extends Node

@onready var viewport_resolution : Vector2 = get_viewport().get_visible_rect().size

@export var is_gesture_tracking_enabled : bool = true

var detected_mouse_position : Vector2 
var is_hand_on_screen : bool = false
var mouse_canvas_margin := 0.20
var prev_pos : Vector2 = DisplayServer.mouse_get_position()
var server_starter : Node = null
var callibration_duration := 0.5


func _process(delta):
	if is_gesture_tracking_enabled:
		_update_mouse_position(delta)

func _update_mouse_position(_delta):
	if not is_hand_on_screen: return
	var pos = _compute_mouse_position(detected_mouse_position)
	Input.warp_mouse(pos * viewport_resolution)

func _compute_mouse_position(pos):
	var usable_width := 1 - (mouse_canvas_margin * 2)
	var scale := 1 / usable_width
	var final_pos := Vector2.ZERO
	final_pos.x = clamp((pos.x - mouse_canvas_margin) * scale, 0, 1)
	final_pos.y = clamp((pos.y - mouse_canvas_margin) * scale, 0, 1)
	return final_pos
