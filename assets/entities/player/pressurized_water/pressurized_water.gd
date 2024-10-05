class_name PressurizedWater
extends Node3D

var player: PlayerEntity
var camera: Camera3D

var nozzle_end_point: Marker3D
var ray: RayCast3D
var steam_particle: CPUParticles3D
var water_particle: CPUParticles3D
var water_audio: AudioStreamPlayer3D
var steam_timer: Timer
#var pressurized_water_gauge: PressurizedWaterGauge = PressurizedWaterGauge.new()

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
var water_available := true
var line_velocity: Vector3
var starting_stream := false
var has_collided := false
var damage: float
var direction: Vector3 = Vector3.ZERO

func _init(player_instance: PlayerEntity) -> void:
	self.player = player_instance

func _ready():
	#pressurized_water_gauge.initialize(self) # TODO: change into better bar handling
	camera = player.get_node("player-camera")
	water_audio = player.get_node("sounds/pressurized_water")
	nozzle_end_point = camera.get_node("nozzle_end_point")
	ray = player.get_node("raycasts/water_ray")
	steam_particle = player.get_node("particles/steam_particles")
	water_particle = player.get_node("water_particles")
	current_position = player.to_local(nozzle_end_point.global_position)
	damage = Global.equipment_settings.calculate_stat(["nozzle", "damage"])
	print_rich("[color=green]{0} Initialized[/color]".format([self.get_script().get_global_name()]))
	print_rich("[color=dark_gray]-{0} initialized[/color]".format([camera.name]))
	print_rich("[color=dark_gray]-{0} initialized[/color]".format([water_audio.name]))
	print_rich("[color=dark_gray]-{0} initialized[/color]".format([nozzle_end_point.name]))
	print_rich("[color=dark_gray]-{0} initialized[/color]".format([ray.name]))
	print_rich("[color=dark_gray]-{0} initialized[/color]".format([steam_particle.name]))
	print_rich("[color=dark_gray]-{0} initialized[/color]".format([water_particle.name]))

func update_water_stream(delta):
	water_particle.emitting = (toggle_water and water_available)
	#steam_particle.emitting = (toggle_water and water_available)
	water_audio.stream_paused = !(toggle_water and water_available)
	if not toggle_water or not water_available:
		ray.position = Vector3.ZERO
		ray.target_position = Vector3.ZERO
		current_segment = 0
		current_position = player.to_local(nozzle_end_point.global_position)
	else:
		calculate_trajectory()
	
	#pressurized_water_gauge.update_water_gauge(delta)

func calculate_trajectory() -> void:
	var origin := player.to_local(nozzle_end_point.global_position)
	reset_flow()
	line_velocity = direction * force
	update_particle_position()
	if current_segment < num_segments:
		var time = current_segment * segment_length / line_velocity.length()
		var next_position = origin + line_velocity * time + 0.5 * gravity * time * time # Vector3(0, gravity, 0)
		ray.position = current_position
		ray.target_position = next_position - current_position
		if detect_collision():
			steam_particle.position = next_position
			current_position = origin
		else:
			current_position = next_position
		return
	current_segment = 0
	current_position = origin

func detect_collision() -> bool:
	var collider = ray.get_collider()
	steam_particle.emitting = !(collider == null)
	if collider:
		if not collider is FireInstance:
			current_segment += 1
			return false
		if collider.health > 0:
			collider.fire_state_manager.damage_fire(damage)
			current_segment = 0
		return true
	else:
		current_segment += 1
		return false

func reset_flow():
	var face_front = -camera.transform.basis.z.normalized()
	if (direction - -camera.transform.basis.z.normalized()).length() > 0.8:
		current_segment = 0
	if current_segment == 0 or direction == null:
		direction = face_front
		
func update_particle_position():
	water_particle.global_position = nozzle_end_point.global_position
	water_particle.transform.basis.z = camera.transform.basis.z
