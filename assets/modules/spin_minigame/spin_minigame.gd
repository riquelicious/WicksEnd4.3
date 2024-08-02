class_name Valve
extends StaticBody3D

@export var parent_interactable: Node3D
@export var valve_model: Node3D

var is_rotating := false
var last_angle := 0.0
var total_rotations: int = 0	
var prev_status := true
var previous_gesture : String

func _ready():
	set_process_input(true)

func _process(_delta):
	if not parent_interactable: return 
	if not parent_interactable.positioner.is_interacting: return
	var mouse_pos = get_viewport().get_mouse_position()
	if not Global.gesture_settings.gesture == Global.gesture_settings.gesture_list[0]:
			previous_gesture = Global.gesture_settings.gesture
	if previous_gesture == GlobalControls.mgValve:
		if not is_rotating == prev_status:
			is_rotating = true
			prev_status = is_rotating
			last_angle = get_angle_to_mouse(mouse_pos)
	else:
		is_rotating = false
	if is_rotating:
		var current_angle = get_angle_to_mouse(mouse_pos)
		var angle_delta = current_angle - last_angle
		rotate_object_local(Vector3(0, 0, 1), -angle_delta)
		if last_angle > 0.9 and current_angle < 0.1:
			total_rotations += 1
		if last_angle < 0.1 and current_angle > 0.9:
			total_rotations -= 1
		last_angle = current_angle

func get_angle_to_mouse(mouse_pos: Vector2) -> float:
	var camera = get_viewport().get_camera_3d()
	var valve_global_position = global_transform.origin
	var valve_screen_pos = camera.unproject_position(valve_global_position)
	var mouse_vector = (mouse_pos - valve_screen_pos).normalized()
	return atan2(mouse_vector.y, mouse_vector.x)
