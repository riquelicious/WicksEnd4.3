class_name InventoryManager
extends Node

var parent : Node
var item_container : VBoxContainer
var toggle_timer : Timer
var inventory_gesture : String
var player_occupied : bool
var previous_gesture : String = ""
var is_inventory : bool = false
var equipment_index : int = 0
var inventory_ui : Control
var current_index : int = 0
var anim : AnimationPlayer
var is_ext := true

func initialize(parent_instance : Node):
	parent = parent_instance
	item_container = parent.get_node("Control/on-screen-ui/ui/inventory/background/rows")
	toggle_timer = parent.get_node("timers/inventory_delay")
	inventory_ui = parent.get_node("Control/on-screen-ui/ui/inventory")
	inventory_gesture = GlobalControls.uiInventory
	player_occupied = parent.interaction_manager.is_civilian_carried
	anim = parent.get_node("Control/on-screen-ui/ui/inventory/AnimationPlayer")
	if Global.level_settings.level_selection < 2:
		is_ext = false

func toggle_inventory(delta):
	if not player_occupied:
		if parent.is_aim_active: return
		stop_timer()
		if toggle_timer.time_left == 0:
			if Global.gesture_settings.gesture == inventory_gesture:
				is_inventory = !is_inventory
				previous_gesture = Global.gesture_settings.gesture
				toggle_timer.start(Global.gameplay_settings.uiInvToggleSpeed)	
				animate_inv(is_inventory)

func stop_timer():
	if Global.gesture_settings.gesture != previous_gesture:
		toggle_timer.stop()

func select_equipment():
	equipment_index = GlobalControls.invControls.find(Global.gesture_settings.gesture)
	if not is_ext:
		if equipment_index == 2:
			equipment_index = -1
	if equipment_index >= 0:
		parent.equipment_manager.change_equipment(equipment_index)
		current_index = equipment_index
		update_name_color(equipment_index)
	
func update_name_color(index):
	for item in item_container.get_children():
		var child : Label = item.get_node("equipment_name")
		child.label_settings.font_color = Color.GRAY
	item_container.get_child(index).get_node("equipment_name").label_settings.font_color = Color.WHITE

func animate_inv(status):
	if status:
		anim.play("fade")
	else:
		anim.play_backwards("fade")
