class_name ExtinguisherManager 
extends Node

var parent : Node
var camera : Camera3D
var extinguisher_particle : CPUParticles3D
var ray : RayCast3D
var extinguisher_tip : Marker3D

var damage : float

var update_speed : float = 0.3
var time : float = 0.0
var toggle_extinguisher := false

func initialize(parent_instance : Node):
	parent = parent_instance
	ray = parent.get_node("player-camera/extinguisher_raycast")
	extinguisher_particle = parent.get_node("extinguisher_particle")
	camera = parent.get_node("player-camera")
	extinguisher_tip = camera.get_node("nozzle_end_point")
	damage = Global.equipment_settings.calculate_stat(["extinguisher","damage"])

func update_extinguisher(delta):
	extinguisher_particle.emitting = toggle_extinguisher
	update_particle_position()
	if not toggle_extinguisher:
		time = 0.0
		return
	time += delta
	if time < update_speed: return
	detect_collision()


func detect_collision() -> bool:
	var collider = ray.get_collider()
	if collider:
		if collider.health > 0:
			collider.fire_state_manager.damage_fire(damage)
	return !(collider == null)


func update_particle_position():
	extinguisher_particle.global_position = extinguisher_tip.global_position
	extinguisher_particle.transform.basis.z = camera.transform.basis.z
