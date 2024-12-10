extends Node3D

var anim_manager: MenuAnimationManager = MenuAnimationManager.new()
var button_manager: MenuButtonManager = MenuButtonManager.new()
var camera_manager: MenuCameraManager = MenuCameraManager.new()

@onready var ending = $"UI/ending_scene/SceneManager"

signal visibility_change

func _ready():
	anim_manager.initialize(self)
	button_manager.initialize(self)
	camera_manager.initialize(self)
	if Global.gameplay_settings.from_level:
		anim_manager.switch_ui(1)
		Global.gameplay_settings.from_level = false
	else:
		anim_manager.switch_ui(0)
	# var bgm = preload("res://Assets/Audio/BGM/ThreeCandles.mp3")
	# BGM.stream = bgm
	# BGM.play()


func _process(delta: float) -> void:
	camera_manager.update_camera_position(delta)
