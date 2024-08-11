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
var ext_available := true
var gauge : Gauge = Gauge.new()

func initialize(parent_instance : Node):
	parent = parent_instance
	ray = parent.get_node("player-camera/extinguisher_raycast")
	extinguisher_particle = parent.get_node("extinguisher_particle")
	camera = parent.get_node("player-camera")
	gauge.initialize(self)
	extinguisher_tip = camera.get_node("nozzle_end_point")
	damage = Global.equipment_settings.calculate_stat(["extinguisher","damage"])

func update_extinguisher(delta):
	gauge.update_water_gauge(delta)
	extinguisher_particle.emitting = toggle_extinguisher and ext_available
	gauge.active = toggle_extinguisher and ext_available
	update_particle_position()
	if not toggle_extinguisher or not ext_available:
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




class Gauge:
	var parent
	var active := false
	var timer := 0.0
	const update_delay := 2.0
	var ext_depletion : float
	var ext_replenish : float

	func initialize(parent_instance):
		parent = parent_instance
		ext_depletion = Global.equipment_settings.calculate_stat(["extinguisher","capacity","decrease"])
		ext_replenish = Global.equipment_settings.calculate_stat(["extinguisher","capacity","increase"])


	func update_water_gauge(delta):
		update_water_status(delta)
		if active:
			parent.parent.extinguisher = clamp(parent.parent.extinguisher - (ext_depletion * delta), 0, 100)
		else:
			parent.parent.extinguisher =  clamp(parent.parent.extinguisher + (ext_replenish * delta), 0, 100)

	func update_water_status(delta):
		if not parent.toggle_extinguisher: return
		if parent.parent.extinguisher <= 0.0:
			parent.ext_available = false
		else:
			timer += delta
			if timer < update_delay: return
			timer = 0.0
			parent.ext_available = true
