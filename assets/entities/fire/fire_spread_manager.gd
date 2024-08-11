class_name FireSpreadManager
extends Node3D

var fire : FireInstance 
var fire_rays : Array
var update_timer : Timer
var initial_update_timer : Timer
var upd_interval : float 

func initialize(fire_instance : FireInstance):
	fire = fire_instance
	upd_interval = Global.fire_settings.fire_update_speed
	fire_rays = fire.get_node("raycasts").get_children()
	update_timer = fire.get_node("timers/update_delay")
	initial_update_timer = fire.get_node("timers/initial_update_timer")
	initial_update_timer.timeout.connect(initial_update)
	update_timer.timeout.connect(update_surroundings)
	initial_update_timer.start()
	update_timer.start(upd_interval)

func update_surroundings() -> void:
	if update_timer.is_stopped() : return
	fire.fire_state_manager.regenerate_health()  
	for ray in fire_rays:
		var collider = ray.get_collider()
		if not collider: continue
		if collider.health <= 0: 
			if fire.health > 0:
				spawn_fire(collider)
		else:
			if ray.name.to_lower() == "top":
				fire.fire_texture_manager.update_position(true)
	if update_timer.get_wait_time() != upd_interval:
		update_timer.set_wait_time(upd_interval)
		update_timer.start()

func initial_update():
	for ray in fire_rays:
		var collider = ray.get_collider()
		if collider:
			if collider.health > 0:
				if ray.name.to_lower() == "top":
					fire.fire_texture_manager.update_position(true)
		else:
			ray.enabled = false

func update_bottom(is_bottom: bool) -> void:
	for ray in fire_rays:
		if ray.name.to_lower() == "bottom":
			var collider = ray.get_collider()
			if collider:
				collider.fire_texture_manager.update_position(is_bottom)

func spawn_fire(collider) -> void:
	var num = (randi() % Global.fire_settings.fire_update_chances) + 1
	if (ceil(num) == Global.fire_settings.fire_update_chances):
		collider.fire_state_manager.kindle_fire()
