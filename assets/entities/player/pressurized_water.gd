class_name Pressurized_Water
extends Node3D

@onready var player: CharacterBody3D = $"../.."
@onready var camera: Camera3D = $"../../player-camera"
@onready var water_mesh := preload("res://assets/models/equipments/Water/water.tscn")
@onready var mesh_container := $mesh_container
@onready var player_camera := get_viewport().get_camera_3d()
@onready var water_audio := $water_audio

@export var nozzle_end_point: Marker3D
@export var delay: Timer
@export var curved_ray: RayCast3D
@export var steam_particles: CPUParticles3D

var toggle_water := false
# * water physics
var force := 20.0
var gravity := -9.8
var line_velocity: Vector3
# * water mesh
var line_thickness := 0.04
var line_height := 0.04
var draw_speed := 0.005
var num_segments := 10
var segment_length := 0.5
var current_segment := 0
@onready var current_position := to_local(nozzle_end_point.global_position) # position
# * draw speed and timings
var update_time := 0.0
var has_collided := false
var starting_stream := true
# * particles
var steam_timer: Timer

func _ready() -> void:
	water_audio.finished.connect(_loop_audio)
	water_audio.volume_db = linear_to_db(Global.audio_settings.default_water_linear_volume)
	steam_timer = steam_particles.get_child(0)
	steam_timer.timeout.connect(_stop_steam_emitting)

func _physics_process(delta) -> void:
	# ? starting stream is slower
	if starting_stream:
		update_time += delta
		if update_time < 0.02: return
		update_time = 0.0
	# ? runs stream
	if not toggle_water:
		for child in mesh_container.get_children():
			child.queue_free()
		curved_ray.position = Vector3.ZERO
		curved_ray.target_position = Vector3.ZERO
		steam_particles.emitting = false
		current_segment = 0
		starting_stream = true
		current_position = to_local(nozzle_end_point.global_position) # position
		if not water_audio.stream_paused:
			water_audio.stream_paused = true
	else:
		if water_audio.stream_paused:
			water_audio.stream_paused = false
			water_audio.autoplay = true
		_calculate_trajectory()

func _calculate_trajectory() -> void:
	var origin := to_local(nozzle_end_point.global_position)
	var direction = -camera.transform.basis.z.normalized()
	line_velocity = direction * force
	if current_segment < num_segments:
		var time = current_segment * segment_length / line_velocity.length()
		var next_position = origin + line_velocity * time + 0.5 * Vector3(0, gravity, 0) * time * time
		curved_ray.position = current_position
		curved_ray.target_position = next_position - current_position
		var collider = curved_ray.get_collider()
		if collider:
			if collider.health > 0:
				has_collided = true
				steam_particles.emitting = true
				steam_particles.position = next_position
				collider.damange_fire(Global.equipment_settings.equipments["nozzle"]["damage"])
				current_segment = 0
				current_position = origin
				_kill_other_mesh(current_segment)
		else:
			has_collided = false
		draw_cube(current_position, next_position, line_thickness, line_height, current_segment)
		current_position = next_position
		current_segment += 1
	else:
		if not has_collided:
			_stop_steam_emitting()
		current_segment = 0
		current_position = origin
		starting_stream = false

func draw_cube(start, end, thickness, height, index) -> void:
	var mesh: MeshInstance3D = water_mesh.instantiate()
	var custom_scale = Vector3(thickness, height, (end - start).length())
	mesh.scale = custom_scale
	var mid_point = (start + end) / 2
	mesh.transform.origin = mid_point
	var direction = (end - start).normalized()
	var right = direction.cross(Vector3.UP).normalized()
	var new_up = right.cross(direction).normalized()
	if new_up != Vector3.ZERO:
		mesh.look_at_from_position(mesh.transform.origin, mesh.transform.origin + direction, new_up)
	if mesh_container.get_child_count() >= index + 1:
		var child = mesh_container.get_child(index)
		mesh_container.add_child(mesh)
		mesh_container.move_child(mesh, index)
		child.queue_free()
	else:
		mesh_container.add_child(mesh)

func _stop_steam_emitting() -> void:
	steam_particles.emitting = false

func _kill_other_mesh(index) -> void:
	var child_count = mesh_container.get_child_count()
	if child_count > index + 1:
		for i in range(index + 1, child_count):
			var child = mesh_container.get_child(i)
			child.queue_free()
	
func _loop_audio():
	water_audio.stream_paused = false
	water_audio.play()
