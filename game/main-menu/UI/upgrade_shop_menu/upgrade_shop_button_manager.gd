class_name UpgradeShopButtonManager extends Node

var parent: UpgradeShopMenu
var button_container: Array
var previous_button
var upgrade_node: Control
var downgrade_node: Control
var upgrade_button: HoverButton
var downgrade_button: HoverButton

func _init(parent_instance: UpgradeShopMenu):
	self.parent = parent_instance

func _ready() -> void:
	button_container = parent.get_node("ColumnContainer/shopControls/controlContainers/controlButtons").get_children()
	upgrade_node = parent.get_node("ColumnContainer/shopDisplays/ItemInfo/HBoxContainer/upgrade_button/upgrade/CenterContainer/Button")
	downgrade_node = parent.get_node("ColumnContainer/shopDisplays/ItemInfo/HBoxContainer/upgrade_button/down_grade/CenterContainer/Button")
	upgrade_button = HoverButton.new(upgrade_node, upgradeFunc)
	downgrade_button = HoverButton.new(downgrade_node, downgradeFunc)
	assert(upgrade_node, "Upgrade Shop Button Manager: Upgrade Node not found!")
	assert(downgrade_node, "Upgrade Shop Button Manager: Downgrade Node not found!")
	upgrade_button._ready()
	downgrade_button._ready()
	update_icon()
	pick_button(0)

func update_icon():
	var index = 0
	for button in button_container:
		var icon_index = GlobalControls.upgradeShopControls[index]
		button.get_node("buttonIcon").texture = FilePaths.gesture_icons[icon_index]
		index += 1

func pick_button(index: int):
	previous_button = index
	parent.equipment_index = index
	for button in button_container:
		button.get_node("Label").label_settings.font_color = Color.GRAY
		button.get_node("buttonIcon").material["shader_parameter/invert_amount"] = 1
	var picked = button_container[index]
	picked.get_node("Label").label_settings.font_color = Color.WHITE
	picked.get_node("buttonIcon").material["shader_parameter/invert_amount"] = 0

func update_buttons():
	var button_index = Global.gesture_settings.get_index_from(GlobalControls.upgradeShopControls)
	if button_index != -1 and button_index != previous_button:
		pick_button(button_index)

func _process(_delta: float) -> void:
	update_buttons()
	upgrade_button._process(_delta)
	downgrade_button._process(_delta)


func upgradeFunc():
	pass


func downgradeFunc():
	pass
