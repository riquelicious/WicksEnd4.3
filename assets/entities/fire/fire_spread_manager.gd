class_name FireSpreadManager
extends Node3D

var fire : FireInstance 
var fire_rays : Array
var time : float = 0.0 
var initial_update_timer : Timer
var upd_interval : float 

func initialize(fire_instance : FireInstance):
	fire = fire_instance
	upd_interval = Global.fire_settings.fire_update_speed
	fire_rays = fire.get_node("raycasts").get_children()
	initial_update_timer = fire.get_node("update_timer")
	initial_update_timer.timeout.connect(initial_update)
	initial_update_timer.start()

func update_surroundings(delta) -> void:
	time += delta
	if not time >= upd_interval: return
	time = 0.0
	fire.fire_state_manager.regenerate_health() 
	for ray in fire_rays:
		var collider = ray.get_collider()
		if collider:
			if collider.health <= 0 and fire.health > 0: 
				spawn_fire(collider)
			update_position(ray.name, collider) 

func initial_update():
	for ray in fire_rays:
		var collider = ray.get_collider()
		if collider:
			update_position(ray.name, collider) 

func update_position(ray_name: String, collider: Node3D) -> void:
	match ray_name.to_lower():
		"top":
			fire.fire_texture_manager.update_position(collider.health <= 0)
		"bottom":
			collider.fire_texture_manager.update_position(fire.health > 0)
		_:
			return

func spawn_fire(collider) -> void:
	var num = randi() % Global.fire_settings.fire_update_chances
	if (ceil(num) == Global.fire_settings.fire_update_chances):
		collider.kindle_fire()
