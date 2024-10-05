class_name InventoryManager
extends Node

var player: PlayerEntity
var item_container: VBoxContainer
var toggle_timer: Timer
#var inventory_gesture: String
var player_occupied: bool
var previous_gesture: int
#var is_inventory: bool = false
var equipment_index: int = 0
var inventory_ui: Control
#var current_index: int = 0
var anim: AnimationPlayer
var extinguisherAvailable := true

enum equipments {
	NOZZLE,
	AXE,
	FIRE_EXTINGUISHER
}


var current_equipment: int = equipments.NOZZLE


func _init(player_instance: PlayerEntity) -> void:
	self.player = player_instance

func _ready():
	item_container = player.get_node("Control/on-screen-ui/ui/inventory/background/rows")
	toggle_timer = player.get_node("timers/inventory_delay")
	inventory_ui = player.get_node("Control/on-screen-ui/ui/inventory")
	anim = player.get_node("Control/on-screen-ui/ui/inventory/AnimationPlayer")
	if Global.level_settings.level_selection < 2: # TODO
		extinguisherAvailable = false
	print_rich("[color=green]InventoryManager Initialized[/color]")
	print_rich("[color=dark_gray]-{0} initialized[/color]".format([item_container.name]))
	print_rich("[color=dark_gray]-{0} initialized[/color]".format([toggle_timer.name]))
	print_rich("[color=dark_gray]-{0} initialized[/color]".format([inventory_ui.name]))
	print_rich("[color=dark_gray]-{0} initialized[/color]".format([anim.name]))

func toggle_inventory(delta):
	if player.is_occupied() and player.current_state != player.state.INVENTORY: return
	stop_timer()
	if toggle_timer.time_left == 0:
		if Global.gesture_settings.is_gesture_matching(GlobalControls.inventory):
			if player.current_state == player.state.INVENTORY:
				player.current_state = player.state.IDLE
			else:
				player.current_state = player.state.INVENTORY
			previous_gesture = Global.gesture_settings.current_gesture
			toggle_timer.start(Global.gameplay_settings.uiInvToggleSpeed)
			animate_inv(player.current_state == player.state.INVENTORY)

func stop_timer():
	if toggle_timer.is_stopped(): return
	if not Global.gesture_settings.is_gesture_matching(previous_gesture):
		toggle_timer.stop()

func select_equipment():
	if not player.current_state == player.state.INVENTORY: return
	equipment_index = Global.gesture_settings.get_index_from(GlobalControls.inventoryControls)
	if not extinguisherAvailable and equipment_index == 2:
		equipment_index = -1
	if equipment_index >= 0:
		player.equipment_manager.change_equipment(equipment_index)
		current_equipment = equipment_index
		update_name_color(equipment_index)
	
func update_name_color(index):
	for item in item_container.get_children():
		var child: Label = item.get_node("equipment_name")
		child.label_settings.font_color = Color.GRAY
	item_container.get_child(index).get_node("equipment_name").label_settings.font_color = Color.WHITE

func animate_inv(status):
	if status:
		anim.play("fade")
	else:
		anim.play_backwards("fade")

func _process(delta):
	toggle_inventory(delta)
	select_equipment()
