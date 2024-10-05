class_name ValveManager
extends Node

var parent: Node3D
var valve_model: Node3D
var valve_anim: AnimationPlayer
var rotating := false
var last_angle
var total_rotations: int = 0
var previous_ration_status := true
var previous_gesture: int
var finished := false
var cam_reset := false
var player: PlayerEntity
var GlobalGestures = Global.gesture_settings
func initialize(parent_instance: Node3D):
	parent = parent_instance
	valve_anim = parent.get_node("valve_module/valve_animation")
	valve_model = parent.get_node("valve_module")
	parent.set_process_input(true)
	player = parent.get_node("%player")

func update_rotation(_delta):
	if finished: return
	if not parent.positioner.is_interacting:
		return
	var mouse_pos = parent.get_viewport().get_mouse_position()
	if filter_geture():
		if not last_angle:
			last_angle = get_angle_to_mouse(mouse_pos)
		rotate_model(mouse_pos)
	else:
		last_angle = null

func filter_geture() -> bool:
	if GlobalGestures.is_gesture_matching(GlobalControls.valve):
		previous_gesture = GlobalGestures.current_gesture
	if previous_gesture == GlobalControls.valve:
		return true
	return false

func rotate_model(mouse_pos):
	var current_angle = get_angle_to_mouse(mouse_pos)
	var angle_delta = current_angle - last_angle
	if last_angle > 0.9 and current_angle < 0.1:
		total_rotations += 1
	if last_angle < 0.1 and current_angle > 0.9:
		if total_rotations == 0: return
		total_rotations -= 1
	valve_model.rotate_object_local(Vector3(0, 0, 1), -angle_delta)
	last_angle = current_angle
	if total_rotations == parent.rotation_amount:
		finished = true
		animate_valve()

func get_angle_to_mouse(mouse_pos: Vector2) -> float:
	var camera = parent.get_viewport().get_camera_3d()
	var valve_global_position = valve_model.global_transform.origin
	var valve_screen_pos = camera.unproject_position(valve_global_position)
	var mouse_vector = (mouse_pos - valve_screen_pos).normalized()
	return atan2(mouse_vector.y, mouse_vector.x)

func animate_valve():
	valve_anim.play("turn")
	await valve_anim.animation_finished
	player.camera_manager.reset_camera_position()
	Global.level_settings.lvlPoints += parent.points_to_add
	parent.objective_marker.remove_marker()
