class_name MenuButtonManager
extends Node

var parent : Node
var main_menu : Control
var level_select : Control
var upgrade_shop : Control

var level_anim : AnimationPlayer

var new_game_button : Control
var continue_button : Control
var quit_button : Control

var play_button : Control
var upgrade_button : Control
var back_button : Control
var left_button : Control
var right_button : Control

var back_button_shop : Control

func initialize(parent_instance : Node):
	parent = parent_instance
	main_menu = parent.get_node("UI/main_menu")
	level_select = parent.get_node("UI/level_selector")
	upgrade_shop = parent.get_node("UI/UpgradeShop")
	
	new_game_button = main_menu.get_node("ui/VBoxContainer/new-game")
	continue_button = main_menu.get_node("ui/VBoxContainer/continue")
	quit_button = main_menu.get_node("ui/VBoxContainer/quit")

	play_button = level_select.get_node("ui/image")
	upgrade_button = level_select.get_node("ui/Gesture Buttons/Upgrade")
	back_button = level_select.get_node("ui/Gesture Buttons/Back")
	left_button = level_select.get_node("ui/move-left")
	right_button = level_select.get_node("ui/move-right")
	back_button_shop = upgrade_shop.get_node("back")
	connect_buttons()

func connect_buttons():
	new_game_button.button_clicked.connect(new_game_)
	continue_button.button_clicked.connect(continue_)
	quit_button.button_clicked.connect(quit_)

	play_button.button_clicked.connect(play_)
	left_button.button_clicked.connect(left_button_)
	right_button.button_clicked.connect(right_button_)
	upgrade_button.button_activated.connect(upgrade_)
	back_button.button_activated.connect(back_)

	back_button_shop.button_clicked.connect(back_shop_)

func new_game_():
	SaveManager.new_data()   
	parent.anim_manager.switch_ui(1)

func continue_():
	SaveManager.load_data() 
	parent.anim_manager.switch_ui(1)

func quit_():
	SaveManager.save_data()
	Transition.just_fade()
	await Transition.just_fade_finished
	parent.get_tree().quit()

func left_button_():
	Global.level_settings.level_selection = posmod(Global.level_settings.level_selection - 1, 4)
	update_level_camera(Global.level_settings.level_selection)

func right_button_():
	Global.level_settings.level_selection = posmod(Global.level_settings.level_selection + 1, 4)
	update_level_camera(Global.level_settings.level_selection)

func play_():
	Transition.change_scene(FilePaths.levels[Global.level_settings.level_selection])

func upgrade_():
	parent.anim_manager.switch_ui(2)

func back_():
	parent.anim_manager.switch_ui(0)
	
func update_level_camera(index : int):
	parent.anim_manager.switch_level(index)

func back_shop_():
	parent.anim_manager.switch_ui(1)
	SaveManager.save_data()
