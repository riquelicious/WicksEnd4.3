class_name FireDamageManager
extends Node3D

var dmg_interval : float 
var dmg_timer : Timer
var fire : FireInstance
var player : CharacterBody3D 

func initialize(fire_instance : FireInstance):
	fire = fire_instance
	dmg_interval = Global.fire_settings.fire_damage_cooldown_speed
	fire.body_entered.connect(body_entered)
	fire.body_exited.connect(body_exited)
	dmg_timer = fire.get_node("timers/player_damage_delay")

func update_damage(delta):
	if fire.health <= 0: return
	if player:
		var dmg = Global.fire_settings.fire_damage_value
		player.interaction_manager.damage_player(dmg)

func body_entered(body):
	player = body

func body_exited(body):
	player = null
