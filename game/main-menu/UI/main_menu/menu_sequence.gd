class_name MenuSequence extends Control

# Signals for transition
signal menu_hidden
signal menu_visible
signal camera_transitioned

# Nodes
var menu_animation: AnimationPlayer
var menus: Array
var scene_manager: CutSceneManager
# enums
var current_menu: int
enum Menu {
	MAIN_MENU,
	LEVEL_SELECT,
	UPGRADE_SHOP,
	EVIDENCE_MENU
}

# states
var waiting_for_camera: bool = false
var is_hidden: bool = false

func _ready() -> void:
	menu_animation = get_node_or_null("AnimationPlayer")
	scene_manager = get_node_or_null("EndingCutsceneManager")
	assert(menu_animation != null)
	assert(scene_manager != null)
	if Global.gameplay_settings.onGame == false:
		current_menu = Menu.MAIN_MENU
		Global.gameplay_settings.onGame = true
	else:
		current_menu = Menu.LEVEL_SELECT
	_initialize_menus()
	get_menu(Menu.EVIDENCE_MENU).evidence_complete.connect(start_note_ending)
	ready_menu()

func ready_menu() -> void:
	if waiting_for_camera == true:
		waiting_for_camera = false
		await show_menu()
		waiting_for_camera = true
	else:
		show_menu()

func _initialize_menus() -> void:
	for menu in self.get_children():
		if menu is Control and not menu is CutSceneManager:
			menus.append(menu)

func set_menu(menu: Menu) -> void:
	current_menu = menu
	hide_menu()
	show_menu()

func hide_menu() -> void:
	is_hidden = true
	menu_animation.play("FadeUI")
	await menu_animation.animation_finished
	for menu in menus:
		menu.hide()
		menu.mouse_filter = MOUSE_FILTER_IGNORE
		menu.process_mode = Node.PROCESS_MODE_DISABLED
	emit_signal("menu_hidden")
	is_hidden = false

func show_menu() -> void:
	if waiting_for_camera:
		await camera_transitioned
	else:
		if is_hidden:
			await menu_hidden
		else:
			for menu in menus:
				menu.hide()
				menu.mouse_filter = MOUSE_FILTER_IGNORE
				menu.process_mode = Node.PROCESS_MODE_DISABLED
	menus[current_menu].show()
	menus[current_menu].mouse_filter = MOUSE_FILTER_STOP
	menus[current_menu].process_mode = Node.PROCESS_MODE_INHERIT
	menu_animation.play_backwards("FadeUI")
	await menu_animation.animation_finished
	emit_signal("menu_visible")

func get_menu(menu: Menu) -> Control:
	return menus[menu]

func start_note_ending() -> void:
	print_debug("Starting Note Ending")
	scene_manager.set_scene(CutSceneManager.SCENE.NOTE_FINISH, start_ending)
	scene_manager.start_scene(0)


func start_ending() -> void:
	print_debug("Starting Ending")
