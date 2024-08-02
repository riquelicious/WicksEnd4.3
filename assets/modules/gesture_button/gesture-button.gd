class_name GestureButton
extends Control

signal button_activated

@export var button_fallback_gesture : int = 0
var button_gesture
#var value

var gesture_button_animation_manager : GestureButtonAnimationManager = GestureButtonAnimationManager.new()
var gesture_button_manager : GestureButtonManager = GestureButtonManager.new()

func _ready():
	gesture_button_animation_manager.initialize(self)
	gesture_button_manager.initialize(self)
	
func reinitialize():
	gesture_button_manager.initialize(self)

func _process(delta):
	gesture_button_manager.update_button_state(delta)
