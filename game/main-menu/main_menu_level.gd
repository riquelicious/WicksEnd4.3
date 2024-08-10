extends Node3D

var anim_manager : MenuAnimationManager = MenuAnimationManager.new()
var button_manager : MenuButtonManager = MenuButtonManager.new()
var camera_manager : MenuCameraManager = MenuCameraManager.new()

signal visibility_change

func _ready():
	anim_manager.initialize(self)
	button_manager.initialize(self)
	camera_manager.initialize(self)
	anim_manager.switch_ui(0)


func _process(delta: float) -> void:
	camera_manager.update_camera_position(delta)
