class_name HoverButton extends Control

var one_shot: bool = false
var disabled: bool = false

var hoverAnimationManager: HoverAnimationManager = HoverAnimationManager.new(self)
var callback: Callable
var buttonNode: Control
var buttonLabel: Label

var maxCooldown: float = 0.3
var spam_timer: float = 0.0

var is_hovering: bool = false
var previous_status: bool = false
var can_be_disabled: bool = false

func _init(button_instance: Control, callback_func: Callable) -> void:
	self.buttonNode = button_instance
	self.callback = callback_func

func _ready():
	hoverAnimationManager._ready()
	buttonLabel = buttonNode.get_node_or_null("button-label")
	buttonNode.mouse_entered.connect(_mouse_entered.bind())
	buttonNode.mouse_exited.connect(_mouse_exited.bind())
	#assert(buttonLabel != null)

func _process(delta):
	check_button_status()
	if hoverAnimationManager.is_executed:
		if spam_timer < maxCooldown:
			spam_timer += delta
			return
	spam_timer = 0.0
	hoverAnimationManager.is_executed = false
	if is_hovering and hoverAnimationManager.is_looped:
		hoverAnimationManager.is_looped = false
		hoverAnimationManager.fade_in()

func check_button_status():
	if previous_status == disabled: return
	previous_status = disabled
	if can_be_disabled:
		if disabled and buttonLabel != null:
			buttonLabel.modulate = Color(1.0, 1.0, 1.0, 0.5)
		else:
			buttonLabel.modulate = Color.WHITE

func _mouse_entered():
	if disabled: return
	is_hovering = true
	
	
func _mouse_exited():
	if disabled: return
	is_hovering = false
	if not hoverAnimationManager.is_looped:
		hoverAnimationManager.fade_out()
		hoverAnimationManager.is_looped = true
