class_name PointManager
extends Node

var player : PlayerA 
var current_points := 0
var label_foreground : Label
var label_background : Label
var point_anim : AnimationPlayer
var popped := false
var point_sfx : AudioStreamPlayer2D

func initialize(player_instance : PlayerA):
	player = player_instance
	point_sfx = player.get_node("Control/on-screen-ui/ui/point_system_container/HBoxContainer/point_pop")
	label_foreground = player.get_node("Control/on-screen-ui/ui/point_system_container/HBoxContainer/Control/foreground")
	label_background = player.get_node("Control/on-screen-ui/ui/point_system_container/HBoxContainer/Control/background")
	point_anim = player.get_node("Control/on-screen-ui/ui/point_system_container/HBoxContainer/point_animation")
	Global.level_settings.lvlPoints = 0
	label_background.text = str(current_points)
	label_foreground.text = str(current_points)
	
func update_points(delta):
	current_points = ceil(lerp(float(current_points), float(Global.level_settings.lvlPoints), delta * 10))
	label_background.text = str(current_points)
	label_foreground.text = str(current_points)
	if Global.level_settings.lvlPoints != current_points:
		if not popped:
			popped = true
			point_anim.play("point_up")  
			if not point_sfx.playing:
				point_sfx.play()      
	else:
		popped = false
		
