class_name FireDamageManager
extends Node3D

var fire : FireInstance
var player : CharacterBody3D
var dmg_interval : float 
var time : float 
func initialize(fire_instance : FireInstance):
	fire = fire_instance
	dmg_interval = Global.fire_settings.fire_damage_cooldown_speed
	fire.body_entered.connect(body_entered)
	fire.body_exited.connect(body_exited)

func body_entered(body):
	if body is PlayerA:
		player = body

func body_exited(body):
	if body is PlayerA:
		player = null

func update_damage(delta):
	if fire.health <= 0: return
	if player:
		time += delta
		if not time >= dmg_interval : return
		time = 0.0
		var dmg = player.health - Global.fire_settings.fire_damage_value
		player.health = clamp(dmg, 0, 100)
		player.damage_animation_player.play("damage_animation")
	else:
		time = dmg_interval
