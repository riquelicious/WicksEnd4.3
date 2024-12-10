class_name ImageHoverButton extends HoverButton


var polaroid: TextureRect
var playIcon: TextureRect

func _init(button_instance: Control, callback_func: Callable) -> void:
	self.buttonNode = button_instance
	self.callback = callback_func

func _ready():
	hoverAnimationManager._ready()
	polaroid = buttonNode.get_node_or_null("Polaroid")
	playIcon = buttonNode.get_node_or_null("PlaySymbol")
	buttonNode.mouse_entered.connect(_mouse_entered.bind())
	buttonNode.mouse_exited.connect(_mouse_exited.bind())
	assert(polaroid != null)
	assert(playIcon != null)
	check_button_status()

func check_button_status():
	if previous_status == disabled: return
	previous_status = disabled
	print(disabled)
	if can_be_disabled:
		if disabled:
			playIcon.texture = FilePaths.lock_tex
			polaroid.texture = FilePaths.polaroids[4]
		else:
			playIcon.texture = FilePaths.play_tex
			polaroid.texture = FilePaths.polaroids[Global.level_settings.level_selection]

func _process(delta):
	check_button_status()
	if not mouse_filter == 0: return
	is_hovering = buttonNode.get_global_rect().has_point(GlobalCursor.cursor_sprite.position)
	if disabled: return
	if hoverAnimationManager.is_executed:
		if spam_timer < maxCooldown:
			spam_timer += delta
			return
	spam_timer = 0.0
	hoverAnimationManager.is_executed = false
	if is_hovering and hoverAnimationManager.is_looped:
			hoverAnimationManager.is_looped = false
			hoverAnimationManager.fade_in()
	elif not is_hovering and not hoverAnimationManager.is_looped:
			hoverAnimationManager.fade_out()
			hoverAnimationManager.is_looped = true
