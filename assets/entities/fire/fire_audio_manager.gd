class_name FireAudioManager
extends Node3D

var fire : FireInstance
var fire_ambient : AudioStreamPlayer3D
var fire_fx : AudioStreamPlayer3D

var target_volume : float 
var ambient_max_volume : float 
var current_volume : float = 0.0

func initialize(fire_instance : FireInstance):
	fire = fire_instance
	target_volume = Global.audio_settings.default_fire_linear_volume
	ambient_max_volume = Global.audio_settings.default_fire_linear_volume
	fire_ambient = fire.get_node("audio/fire_ambient")
	fire_fx = fire.get_node("audio/fire_fx")
	fire_ambient.volume_db = linear_to_db(ambient_max_volume)
	fire_ambient.finished.connect(loop_audio)
	
func loop_audio():
	fire_ambient.stream_paused = false
	fire_ambient.play()

func volume_lerp(delta):
	if is_equal_approx(target_volume,current_volume): return
	current_volume = lerp(current_volume, target_volume, 10 * delta)
	fire_ambient.volume_db = linear_to_db(current_volume)

func kindled_fire():
	fire_fx.stream = FilePaths.fire_kindled_fx
	fire_fx.play()
	target_volume = ambient_max_volume

func extinguished_fire():
	fire_fx.stream = FilePaths.fire_extinguished_fx
	fire_fx.play()
	target_volume = 0.0
