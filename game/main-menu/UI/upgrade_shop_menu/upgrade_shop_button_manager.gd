class_name UpgradeShopButtonManager extends Node

var parent: UpgradeShopMenu
var button_container: Array
var previous_button
var upgrade_node: Control
var downgrade_node: Control
var upgrade_button: HoverButton
var downgrade_button: HoverButton
var buttonAudio: AudioStreamPlayer2D
var sounds: Array = []
enum SFX {
	DENY,
	ACCEPT,
	REFUND
}
func _init(parent_instance: UpgradeShopMenu):
	self.parent = parent_instance

func _ready() -> void:
	button_container = parent.get_node("ColumnContainer/shopControls/controlContainers/controlButtons").get_children()
	upgrade_node = parent.get_node("ColumnContainer/shopDisplays/ItemInfo/HBoxContainer/upgrade_button/upgrade/CenterContainer/Button")
	downgrade_node = parent.get_node("ColumnContainer/shopDisplays/ItemInfo/HBoxContainer/upgrade_button/down_grade/CenterContainer/Button")
	buttonAudio = parent.get_node("ColumnContainer/ButtonSounds")
	sounds.append(load(FilePaths.upgrade_shop_sounds[0]))
	sounds.append(load(FilePaths.upgrade_shop_sounds[1]))
	sounds.append(load(FilePaths.upgrade_shop_sounds[2]))
	upgrade_button = HoverButton.new(upgrade_node, upgradeFunc)
	downgrade_button = HoverButton.new(downgrade_node, downgradeFunc)
	assert(upgrade_node, "Upgrade Shop Button Manager: Upgrade Node not found!")
	assert(downgrade_node, "Upgrade Shop Button Manager: Downgrade Node not found!")
	upgrade_button._ready()
	downgrade_button._ready()
	upgrade_button.one_shot = false
	downgrade_button.one_shot = false
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
		parent.upgradeDisplayManager.update_display(button_index)
		parent.upgradeDisplayManager.update_text(false)

func _process(_delta: float) -> void:
	update_buttons()
	upgrade_button._process(_delta)
	downgrade_button._process(_delta)

func upgradeFunc():
	var price = parent.upgradeDisplayManager.current_price
	if parent.available_points < price:
		print("Not enough points!")
		play_sound(SFX.DENY)
		return
	play_sound(SFX.ACCEPT)
	parent.available_points -= price
	parent.update_dictionary_stats(1)
	parent.upgradeDisplayManager.update_text(true)

func downgradeFunc():
	var key = parent.temporary_stats.keys()[parent.equipment_index]
	var equipment = parent.temporary_stats[key]
	var temp = parent.temporary_stats[key]["level"]
	var real = Global.equipment_settings.equipments[key]["level"]
	if temp == real:
		play_sound(SFX.DENY)
		return
	play_sound(SFX.REFUND)
	parent.available_points += parent.upgradeDisplayManager.calculate_current_value(equipment, ["price"])
	parent.update_dictionary_stats(-1)
	parent.upgradeDisplayManager.update_text(true)


func play_sound(index: SFX):
	buttonAudio.stream = sounds[index]
	buttonAudio.play()
