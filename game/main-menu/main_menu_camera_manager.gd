class_name MenuCameraManager
extends Node

var parent : Node
var camera : Camera3D
var markers : Array
var target_marker : Marker3D
var preious_status := false
signal camera_movement_finished

func initialize(parent_instance : Node):
	parent = parent_instance
	camera = parent.get_node("Camera3D")
	markers = parent.get_node("camera_positions").get_children()
	target_marker = markers[0]

func update_camera_position(delta):
	if not target_marker: return
	var finished = 0
	if not (camera.position - target_marker.position).length() < 0.005:
		camera.position = lerp(camera.position, target_marker.position, 2 * delta)
	else:
		finished += 1
	if not (camera.rotation - target_marker.rotation).length() < 0.005:
		camera.rotation = lerp(camera.rotation, target_marker.rotation, 2 * delta)
	else:
		finished += 1
	var status = finished == 2
	if status != preious_status:
		if status:
			emit_signal("camera_movement_finished")
	preious_status = status

func update_position(index : int):
	if index > 1:
		index += 3
	target_marker = markers[index]

func update_level(index : int):
	target_marker = markers[index + 1]
