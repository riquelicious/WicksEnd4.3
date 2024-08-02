class_name PressurizedWater
extends Node3D

var player : PlayerA
var camera : Camera3D
var mesh_container : Node3D
var water_audio : AudioStreamPlayer3D
var nozzle_end_point : Marker3D
var delay_timer : Timer
var ray : RayCast3D
var steam_particle : CPUParticles3D
var water_particle : CPUParticles3D
var steam_timer : Timer
var pressurized_water_mesh : PressurizedWaterMesh = PressurizedWaterMesh.new()
var pressurized_water_gauge : PressurizedWaterGauge = PressurizedWaterGauge.new()

const force := 20.0
const gravity := Vector3.DOWN * 9.8
const segment_length := 0.5
const num_segments := 15
const line_thickness := 0.04
const line_height := 0.04

var current_position
var current_segment = 0
var stream_update_delay := 0.0
var toggle_water := false
var line_velocity : Vector3
var starting_stream := false
var has_collided := false
var nozzle_damage : float
var direction 

func initialize(player_instance : PlayerA):
	player = player_instance
	pressurized_water_mesh.initialize(self)
	pressurized_water_gauge.initialize(self)
	camera = player.get_node("player-camera")
	mesh_container = player.get_node("water_mesh_container")
	water_audio = player.get_node("sounds/pressurized_water")
	nozzle_end_point = camera.get_node("nozzle_end_point")
	delay_timer = player.get_node("timers/water_detection_delay")
	ray = player.get_node("raycasts/water_ray")
	steam_particle = player.get_node("particles/steam_particles")
	water_particle = player.get_node("water_particles")
	steam_timer = steam_particle.get_child(0)
	current_position = player.to_local(nozzle_end_point.global_position)
	water_audio.finished.connect(_loop_audio)
	water_audio.volume_db = linear_to_db(Global.audio_settings.default_water_linear_volume)
	steam_timer.timeout.connect(pressurized_water_mesh.stop_steam_emitting)
	nozzle_damage = Global.equipment_settings.calculate_stat(["nozzle","damage"])

func update_water_stream(delta):
	if starting_stream:
		stream_update_delay += delta
		if stream_update_delay < 0.02: return
		stream_update_delay = 0.0
	if not toggle_water: 
		water_particle.emitting = false
		for child in mesh_container.get_children():
			child.queue_free()
		pressurized_water_gauge.active = false
		ray.position = Vector3.ZERO
		ray.target_position = Vector3.ZERO
		steam_particle.emitting = false
		current_segment = 0
		starting_stream = true
		current_position = player.to_local(nozzle_end_point.global_position)#position
		if not water_audio.stream_paused:
			water_audio.stream_paused = true
	else:
		if water_audio.stream_paused:
			water_audio.stream_paused = false
			water_audio.autoplay = true
		pressurized_water_gauge.active = true
		_calculate_trajectory()
		water_particle.emitting = true
	pressurized_water_gauge.update_water_gauge(delta)

#-1.829
func _calculate_trajectory() -> void:
	var origin := player.to_local(nozzle_end_point.global_position)
	if current_segment == 0:
		direction = -camera.transform.basis.z.normalized() 
	if direction == null:
		direction = -camera.transform.basis.z.normalized() 
	if (direction - -camera.transform.basis.z.normalized()).length() > 0.8:
		current_segment = 0
		pressurized_water_mesh.kill_other_mesh(0)
		direction = -camera.transform.basis.z.normalized() 
	line_velocity = direction * force 
	water_particle.global_position = nozzle_end_point.global_position
	water_particle.transform.basis.z = camera.transform.basis.z
	if current_segment < num_segments:
		var time = current_segment * segment_length / line_velocity.length()
		var next_position = origin + line_velocity * time + 0.5 * gravity * time * time #Vector3(0, gravity, 0)
		ray.position = current_position 
		ray.target_position = next_position - current_position 
		var collider = ray.get_collider()
		if collider:
			if collider.health > 0:
				has_collided = true
				if current_segment > 1:
					steam_particle.emitting = true
					steam_particle.position = next_position
				collider.fire_state_manager.damage_fire(nozzle_damage)
				current_segment = 0
				current_position = origin
				pressurized_water_mesh.kill_other_mesh(current_segment)
				#pressurized_water_mesh.draw_cube(current_position, next_position, line_thickness, line_height, current_segment)
				return
		else:
			has_collided = false
			#pressurized_water_mesh.draw_cube(current_position, next_position, line_thickness, line_height, current_segment)
		current_position = next_position
		current_segment += 1
	else:
		if not has_collided:
			pressurized_water_mesh.stop_steam_emitting()
		current_segment = 0
		current_position = origin
		starting_stream = false

func _loop_audio():
	water_audio.stream_paused = false
	water_audio.play()
