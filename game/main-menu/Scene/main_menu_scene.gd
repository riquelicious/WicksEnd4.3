extends Node3D

var camera: Camera3D
var menu_markers: Array
var level_markers: Array
var lerp_speed := 10.0

var current_level: int
var current_menu: int

var preveious_
var target_position: Vector3
var target_rotation: Vector3
var transition_finished: bool = false
var menuSequence: MenuSequence


func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	menu_markers = get_node("CameraPositions").get_children()
	menuSequence = get_node("MenuSequence")
	# ? Gets markers from level node3d
	for marker in menu_markers:
		if marker is Marker3D: continue
		level_markers = marker.get_children()

	assert(camera != null)
	assert(menuSequence != null)
	assert(menu_markers.size() > 0)
	assert(level_markers.size() > 0)

func _process(delta: float) -> void:
	#get_current_level()
	update_menu()
	TransitionCamera(delta)

func get_current_level() -> int:
	if current_level != Global.level_settings.level_selection:
		current_level = Global.level_settings.level_selection
	return current_level

func TransitionCamera(delta: float) -> void:
	if transition_finished: return
	# ? Define target position and rotation
	if current_menu == menuSequence.Menu.LEVEL_SELECT:
		target_position = level_markers[current_level].global_position
		target_rotation = level_markers[current_level].global_rotation
	else:
		target_position = menu_markers[current_menu].global_position
		target_rotation = menu_markers[current_menu].global_rotation

	# ? Moves the camera
	var is_moved = camera.global_position.is_equal_approx(target_position)
	var is_rotated = camera.global_rotation.is_equal_approx(target_rotation)
	print(is_moved, is_rotated)
	if is_moved and is_rotated:
		transition_finished = true
	else:
		camera.global_position = lerp(camera.global_position, target_position, delta * lerp_speed)
		camera.global_rotation = lerp(camera.global_rotation, target_rotation, delta * lerp_speed)
		pass


func update_menu() -> void:
	if current_menu != menuSequence.current_menu:
		transition_finished = false
		current_menu = menuSequence.current_menu
	if current_level != Global.level_settings.level_selection:
		transition_finished = false
		current_level = Global.level_settings.level_selection
