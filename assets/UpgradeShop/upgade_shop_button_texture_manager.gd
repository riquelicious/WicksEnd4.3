class_name ShopButtonTextureManager
extends Node

var parent: Node
var button_container: Array
var background: Control
var target_position: Vector2
var lerp_speed: float = 30
var background_anim: AnimationPlayer
var previous_pos

signal lerp_finished

func initialize(parent_instance: Node):
	parent = parent_instance
	button_container = parent.get_node("buttons").get_children()
	background = parent.get_node("background")
	background_anim = background.get_node("AnimationPlayer")
	update_icons()
	target_position = button_container[0].global_position # - Vector2(0,15)
	background_anim.play("fade")

func update_icons():
	var index = 0
	for button in button_container:
		var icon = button.find_child("button_gesture_icon")
		#var image_index = Global.gesture_settings.gesture_list.find(GlobalControls.usControls[index])
		#var image_index = Global.gesture_settings
		var image_index = GlobalControls.upgradeShopControls[index]
		index += 1
		var image = FilePaths.gesture_icons[image_index]
		icon.texture = image

func move_background(delta):
	var new_target = target_position + Vector2(72, 0)
	if not (background.global_position - new_target).length() < 0.1:
		background.global_position = lerp(background.global_position, new_target, lerp_speed * delta)


func change_target(pos: Vector2):
	target_position = pos

func detect_gesture():
	#var gesture = Global.gesture_settings.current_gesture
	#var index = GlobalControls.upgradeShopControls.find(gesture)
	var index = Global.gesture_settings.current_gesture
	if index >= 0:
		var pos = button_container[index].global_position
		parent.shop_icon_manager.update_icon(index)
		change_target(pos)


# func connect_buttons():
# 	for button in button_container:
# 		var pos = button.global_position
# 		button.mouse_entered.connect(change_target.bind(pos))
