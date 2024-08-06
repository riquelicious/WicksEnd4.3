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

func initialize(parent_instance : Node):
	parent = parent_instance
	item_container = parent.get_node("Control/on-screen-ui/ui/inventory/background/rows")
	toggle_timer = parent.get_node("timers/inventory_delay")
	inventory_ui = parent.get_node("Control/on-screen-ui/ui/inventory")
	inventory_gesture = GlobalControls.uiInventory
	player_occupied = parent.interaction_manager.is_civilian_carried
	inventory_ui.visible = is_inventory

func toggle_inventory(delta):
	if not player_occupied:
		#print(toggle_timer.time_left)
		if parent.is_aim_active: return
		stop_timer()
		if toggle_timer.time_left == 0:
			if Global.gesture_settings.gesture == inventory_gesture:
				is_inventory = !is_inventory
				previous_gesture = Global.gesture_settings.gesture
				toggle_timer.start(Global.gameplay_settings.uiInvToggleSpeed)	
				inventory_ui.visible = !inventory_ui.visible

func stop_timer():
	if Global.gesture_settings.gesture != previous_gesture:
		toggle_timer.stop()

func select_equipment():
	equipment_index = GlobalControls.invControls.find(Global.gesture_settings.gesture)
	if equipment_index >= 0:
		parent.equipment_manager.change_equipment(equipment_index)
		current_index = equipment_index
	
