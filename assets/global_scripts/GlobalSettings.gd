class_name GlobalSettings
extends Node


var fire_settings: FireSettings
var audio_settings: AudioSettings
var gesture_settings: GestureSettings
var level_settings: LevelSettings
var equipment_settings: EquipmentSettings
var gameplay_settings: GameplaySettings

func _ready():
	fire_settings = preload("res://assets/global_scripts/FireSettings.gd").new()
	audio_settings = preload("res://assets/global_scripts/AudioSettings.gd").new()
	gesture_settings = preload("res://assets/global_scripts/GestureSettings.gd").new()
	level_settings = preload("res://assets/global_scripts/LevelSettings.gd").new()
	equipment_settings = preload("res://assets/global_scripts/EquipmentSettings.gd").new()
	gameplay_settings = preload("res://assets/global_scripts/GameplaySettings.gd").new()

	add_child(fire_settings)
	add_child(audio_settings)
	add_child(gesture_settings)
	add_child(level_settings)
	add_child(equipment_settings)
	add_child(gameplay_settings)
