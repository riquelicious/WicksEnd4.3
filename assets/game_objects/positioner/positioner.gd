class_name Positioner
extends Node3D

var player_camera : Camera3D
var parent : Node3D

var camera_position : Marker3D
var do_camera_positioned := false
var default_camera_position 
var is_interacting := false
var camera_reset_finished := false

func initialize(object_instance : Node3D, camera_marker : Marker3D):
	parent = object_instance
	camera_position = camera_marker
	player_camera = parent.get_viewport().get_camera_3d()

func position_camera(delta):
	if not is_interacting: return 
	if do_camera_positioned:
		if not player_camera.global_position.is_equal_approx(camera_position.global_position):
			var pos = lerp(player_camera.global_position,camera_position.global_position, delta * 10)			
			player_camera.look_at_from_position(pos, parent.global_position , Vector3.UP)
	else:
		#player_camera.global_position = default_camera_position
		player_camera.global_position = lerp(player_camera.global_position,default_camera_position, delta * 10)						
		if (player_camera.global_position - default_camera_position).length() < 0.05:
			player_camera.global_position = default_camera_position
			default_camera_position = null
			is_interacting = false
		
