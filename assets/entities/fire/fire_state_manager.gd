class_name FireStateManager
extends Node3D

var fire: FireInstance
var spawn_anim: AnimationPlayer
var fire_illumination: OmniLight3D
var top_ray: RayCast3D
var player: PlayerA
var prev_health: int = 100
var points: int = 50

func initialize(fire_instance: FireInstance):
	fire = fire_instance
	spawn_anim = fire.get_node("spawn_animation")
	fire_illumination = fire.get_node("fire_light")
	top_ray = fire.get_node("raycasts/top")
	player = fire.get_node("%player")
	update_starting_state()

func update_starting_state() -> void:
	if not fire.enabled:
		spawn_anim.play_backwards("fade")
		prev_health = 0
		fire.health = 0
	else:
		fire.fire_count += 1

func regenerate_health() -> void:
	if fire.health > 0:
		fire.health = clamp(fire.health + 5, 0, 100)

func kindle_fire() -> void:
	fire.fire_count += 1
	fire.health = 100
	spawn_anim.play("fade")
	fire.fire_spread_manager.update_timer.start()
	fire.fire_spread_manager.update_bottom(true)
	fire.fire_audio_manager.kindled_fire()
	fire.set_collision_layer_value(12, true)
	fire_illumination.visible = true
	

func extinguish_fire() -> void:
	fire.fire_count -= 1
	print(fire.fire_count)
	fire.fire_damage_manager.player = null
	fire.is_blue = false
	fire.fire_spread_manager.update_timer.stop()
	spawn_anim.play_backwards("fade")
	fire.fire_spread_manager.update_bottom(false)
	fire.fire_audio_manager.extinguished_fire()
	fire.set_collision_layer_value(12, false)
	fire_illumination.visible = false
	Global.level_settings.lvlPoints += points
	points = 10
	if fire.fire_count <= 0:
		print("finished")
		if fire.get_parent().get_parent() is FireSystem:
			fire.get_parent().get_parent().finished = true

func damage_fire(amount):
	if check_fire_type():
		do_damage(amount)
	else:
		var utimer = fire.fire_spread_manager.update_timer
		if utimer.get_wait_time() == fire.fire_spread_manager.upd_interval:
			utimer.set_wait_time(1)
			utimer.start()

func fire_state_listener():
	if prev_health != fire.health:
		prev_health = fire.health
		if fire.health <= 0:
			fire.fire_texture_manager.update_position(false)
			extinguish_fire()

func check_fire_type() -> bool:
	if fire.is_blue:
		return (player.inventory_manager.current_index == 2)
	return true
		
func do_damage(amount):
	fire.fire_spread_manager.update_timer.start()
	if fire.fire_texture_manager.bottom:
		var collider = top_ray.get_collider()
		if collider:
			if collider.health > 0:
				collider.fire_state_manager.damage_fire(amount)
				return
	fire.health = clamp(fire.health - amount, 0, 100)
