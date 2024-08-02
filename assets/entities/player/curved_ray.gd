extends Node3D

@onready var player : CharacterBody3D = $"../.."
@onready var camera : Camera3D = $"../../player-camera"
@onready var water_mesh := preload("res://assets/models/equipments/Water/water.tscn")

@export var nozzle_end_point : Marker3D

var line_thickness := 0.04
var line_height := 0.04
var draw_speed := 0.005
var force := 20.0
var gravity := -9.8
var num_segments := 5
var segment_length := 0.5
var current_segment := 0
var line_velocity
var current_position := position


func _physics_process(_delta):
	if not player.is_aim_active: 
		_kill_instances(0)
		return
	_kill_instances(num_segments)
	_calculate_trajectory()

func _calculate_trajectory():
	var origin := to_local(nozzle_end_point.global_position)
	var direction = -camera.transform.basis.z.normalized() 
	line_velocity = direction * force #+ camera.rotation
	if current_segment < num_segments:
		var time = current_segment * segment_length / line_velocity.length()
		var next_position = origin + line_velocity * time + 0.5 * Vector3(0, gravity, 0) * time * time
		var params = PhysicsRayQueryParameters3D.new()
		params.from = current_position
		params.to = next_position
		params.collision_mask = 9
		var result = get_world_3d().direct_space_state.intersect_ray(params)
		if result:
			pass
		draw_cube(current_position, next_position, line_thickness, line_height)
		current_position = next_position
		current_segment += 1
	else:
		current_segment = 0
		current_position = origin


func draw_cube(start, end, thickness, height):
	var mesh : MeshInstance3D = water_mesh.instantiate()
	var custom_scale = Vector3(thickness,height,(end - start).length())
	mesh.scale = custom_scale

	#?position
	var mid_point = (start + end) / 2
	mesh.transform.origin = mid_point

	#?Direction
	var direction = (end - start).normalized()

	var right = direction.cross(Vector3.UP).normalized()
	var new_up = right.cross(direction).normalized()
	mesh.look_at_from_position(mesh.transform.origin, mesh.transform.origin + direction, new_up)
	
	add_child(mesh)

func _kill_instances(safe_count : int):
	var children = get_child_count()
	if children > safe_count:
		for i in range(0 , children - safe_count):
			var child = get_child(i)
			child.queue_free()
