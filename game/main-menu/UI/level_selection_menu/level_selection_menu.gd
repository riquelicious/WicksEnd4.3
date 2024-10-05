class_name LevelSelectionMenuUI extends Node

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

func _ready() -> void:
	cycleLeftNode = get_node_or_null("SelectionContainer/CycleLeft")
	cycleRightNode = get_node_or_null("SelectionContainer/CycleRight")
	polaroidNode = get_node_or_null("SelectionContainer/polaroidButton")
	evidenceNode = get_node_or_null("SelectionContainer/GestureButton/EvidenceButton")
	shopNode = get_node_or_null("SelectionContainer/GestureButton/ShopButton")
	backNode = get_node_or_null("SelectionContainer/GestureButton/BackButton")
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
	cycleRightButton._ready()
	polaroidButton._ready()
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
	#Transition.change_scene(FilePaths.main_menu_scene)
	pass

func evidenceFunc():
	#Transition.change_scene(FilePaths.evidence_scene)
	pass

func shopFunc():
	#Transition.change_scene(FilePaths.shop_scene)
	pass

func switch_level(index: int):
	var animation_player = polaroidButton.hoverAnimationManager.buttonAnimationPlayer
	assert(animation_player != null)
	animation_player.play("appear")
	polaroidNode.mouse_filter = Control.MOUSE_FILTER_IGNORE
	await animation_player.animation_finished
	#animation_player.play("RESET")
	#parent.camera_manager.update_level(index)
	#await parent.camera_manager.camera_movement_finished
	animation_player.play_backwards("appear")
	await animation_player.animation_finished
	polaroidButton.check_button_status()
	#animation_player.play("appear")
	polaroidNode.mouse_filter = Control.MOUSE_FILTER_STOP
