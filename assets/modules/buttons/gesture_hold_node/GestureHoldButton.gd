class_name GestureHoldButton extends Control

var buttonNode: Control
var callback: Callable
var gesture_index: int
var gestureHoldAnimation: GestureHoldAnimation = GestureHoldAnimation.new(self)
var buttonIcon: TextureRect
var maxCooldown: float = 0.3
var spam_timer: float = 0.0
var previous_gesture: int = 0
var disabled: bool = false

func _ready():
	gestureHoldAnimation._ready()
	self.buttonIcon = buttonNode.get_node_or_null("CenterContainer/HBoxContainer/button_gesture_icon")
	assert(self.buttonIcon != null)
	change_icon()

func _init(button_instance: Control, gesture: int, callback_func: Callable) -> void:
	self.callback = callback_func
	self.buttonNode = button_instance
	self.gesture_index = gesture

func _process(delta):
	if disabled: return
	update_state(delta)

func check_gesture(delta):
	if Global.gesture_settings.is_gesture_matching(gesture_index):
		spam_timer += delta
		if spam_timer > maxCooldown:
			return null
	spam_timer = 0.0
	previous_gesture = Global.gesture_settings.current_gesture
	return previous_gesture

func update_state(delta) -> void:
	var gesture = check_gesture(delta)
	if gesture != null:
		if gesture == gesture_index:
			gestureHoldAnimation.fade_in()
		else:
			if gestureHoldAnimation.buttonAnimationPlayer.is_playing():
				if gestureHoldAnimation.current_anim != "clicked":
					gestureHoldAnimation.fade_out()

func change_icon() -> void:
	buttonIcon.texture = FilePaths.gesture_icons[gesture_index]
