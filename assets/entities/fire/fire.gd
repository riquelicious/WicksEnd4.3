class_name FireInstance
extends Area3D

@export var enabled = true

var fire_texture_manager : FireTextureManager = FireTextureManager.new()
var fire_spread_manager : FireSpreadManager = FireSpreadManager.new()
var fire_state_manager : FireStateManager = FireStateManager.new()
var fire_damage_manager : FireDamageManager = FireDamageManager.new()
var fire_audio_manager : FireAudioManager = FireAudioManager.new()
var health = 100

func _ready() -> void:
	fire_texture_manager.initialize(self)
	fire_spread_manager.initialize(self)
	fire_state_manager.initialize(self)
	fire_damage_manager.initialize(self)
	fire_audio_manager.initialize(self)

func _physics_process(delta):
	fire_state_manager.fire_state_listener()
	fire_audio_manager.volume_lerp(delta)
	fire_damage_manager.update_damage(delta)
	fire_spread_manager.update_surroundings(delta)
	fire_damage_manager.update_damage(delta)
