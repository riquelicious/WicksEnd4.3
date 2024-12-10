class_name LevelSelectionMenuUI extends Node

signal menu_hidden
signal menu_visible
signal camera_transitioned

var cycleLeftNode: Control
var cycleRightNode: Control
var polaroidNode: Control
var evidenceNode: Control
var shopNode: Control
var backNode: Control
var cycleLeftButton: HoverButton
var cycleRightButton: HoverButton
var polaroidButton: ImageHoverButton
var evidenceButton: GestureHoldButton
var shopButton: GestureHoldButton
var backButton: GestureHoldButton

var menuSequence: MenuSequence

var is_hidden: bool = false
var waiting_for_camera: bool = false

func _ready() -> void:
	cycleLeftNode = get_node_or_null("SelectionContainer/CycleLeft")
	cycleRightNode = get_node_or_null("SelectionContainer/CycleRight")
	polaroidNode = get_node_or_null("SelectionContainer/polaroidButton")
	evidenceNode = get_node_or_null("SelectionContainer/GestureButton/EvidenceButton")
	shopNode = get_node_or_null("SelectionContainer/GestureButton/ShopButton")
	backNode = get_node_or_null("SelectionContainer/GestureButton/BackButton")
	if get_parent() is MenuSequence:
		menuSequence = get_parent()
	assert(cycleLeftNode != null)
	assert(cycleRightNode != null)
	assert(polaroidNode != null)
	assert(evidenceNode != null)
	assert(shopNode != null)
	assert(backNode != null)
	cycleLeftButton = HoverButton.new(cycleLeftNode, cycleLeftFunc)
	cycleRightButton = HoverButton.new(cycleRightNode, cycleRightFunc)
	polaroidButton = ImageHoverButton.new(polaroidNode, polaroidFunc)
	evidenceButton = GestureHoldButton.new(evidenceNode, GlobalControls.evidence, evidenceFunc)
	shopButton = GestureHoldButton.new(shopNode, GlobalControls.upgrade, shopFunc)
	backButton = GestureHoldButton.new(backNode, GlobalControls.back, backFunc)
	cycleLeftButton._ready()
	cycleLeftButton.one_shot = false
	cycleRightButton._ready()
	cycleRightButton.one_shot = false
	polaroidButton._ready()
	polaroidButton.can_be_disabled = true
	evidenceButton._ready()
	shopButton._ready()
	backButton._ready()

func _process(delta: float) -> void:
	cycleLeftButton._process(delta)
	cycleRightButton._process(delta)
	polaroidButton._process(delta)
	evidenceButton._process(delta)
	shopButton._process(delta)
	backButton._process(delta)

func cycleLeftFunc():
	Global.level_settings.level_selection = posmod(Global.level_settings.level_selection - 1, 4)
	switch_level(Global.level_settings.level_selection)

func cycleRightFunc():
	Global.level_settings.level_selection = posmod(Global.level_settings.level_selection + 1, 4)
	switch_level(Global.level_settings.level_selection)

func polaroidFunc():
	var level = Global.level_settings.level_selection
	if Global.level_settings.unlocked_levels[str(level)] == true:
		Transition.change_scene(FilePaths.level_scene)

func backFunc():
	if menuSequence is MenuSequence:
		menuSequence.set_menu(MenuSequence.Menu.MAIN_MENU)

func evidenceFunc():
	if menuSequence is MenuSequence:
		menuSequence.set_menu(MenuSequence.Menu.EVIDENCE_MENU)

func shopFunc():
	if menuSequence is MenuSequence:
		menuSequence.set_menu(MenuSequence.Menu.UPGRADE_SHOP)

func switch_level(index: int):
	hide_menu()
	check_play_status()
	show_menu()

func hide_menu() -> void:
	is_hidden = true
	var animation_player = polaroidButton.hoverAnimationManager.buttonAnimationPlayer
	animation_player.play("appear")
	polaroidNode.mouse_filter = Control.MOUSE_FILTER_IGNORE
	await animation_player.animation_finished
	emit_signal("menu_hidden")
	is_hidden = false

func show_menu():
	if waiting_for_camera:
		await camera_transitioned
	else:
		if is_hidden:
			await menu_hidden
	var animation_player = polaroidButton.hoverAnimationManager.buttonAnimationPlayer
	animation_player.play_backwards("appear")
	await animation_player.animation_finished
	polaroidButton.check_button_status()
	polaroidNode.mouse_filter = Control.MOUSE_FILTER_STOP

func check_play_status():
	if not is_hidden: return
	await menu_hidden
	var level = Global.level_settings.level_selection
	var status = Global.level_settings.unlocked_levels[str(level)] != true
	polaroidButton.disabled = status
