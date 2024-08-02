class_name FireStateManager
extends Node3D

var fire : FireInstance
var spawn_anim : AnimationPlayer
var fire_illumination : OmniLight3D
var top_ray : RayCast3D
var prev_health : int = 100
var time : float = 0.0
var points : int = 50

func initialize(fire_instance : FireInstance):
	fire = fire_instance
	spawn_anim = fire.get_node("spawn_animation")
	fire_illumination = fire.get_node("fire_light")
	top_ray = fire.get_node("raycasts/top")
	update_starting_state()

func update_starting_state() -> void:
	if not fire.enabled:
		spawn_anim.play_backwards("fade")
		fire.health = 0

func regenerate_health() -> void:
	if fire.health > 0:
		fire.health = clamp(fire.health + 5, 0 , 100)

func kindle_fire() -> void:
	fire.health = 100
	spawn_anim.play("fade")
	fire.fire_audio_manager.kindled_fire()
	fire.set_collision_layer_value(12,true)
	fire_illumination.visible = true

func extinguish_fire() -> void:
	fire.fire_spread_manager.time = fire.fire_spread_manager.upd_interval
	spawn_anim.play_backwards("fade")
	fire.fire_audio_manager.extinguished_fire()
	fire.set_collision_layer_value(12,false)
	fire_illumination.visible = false
	Global.level_settings.lvlPoints += points
	points = 10

func damage_fire(amount):
	fire.fire_spread_manager.time = 0.0
	if fire.fire_texture_manager.bottom:
		var collider = top_ray.get_collider()
		if collider:
			if collider.health > 0:
				collider.fire_state_manager.damage_fire(amount)
				return
	fire.health -= amount

func fire_state_listener():
	if prev_health != fire.health:
		prev_health = fire.health
		if fire.health <= 0: 
			fire.fire_texture_manager.update_position(false)
			extinguish_fire()