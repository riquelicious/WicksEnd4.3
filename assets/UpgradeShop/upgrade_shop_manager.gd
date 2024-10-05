class_name ShopManager
extends Node

var parent: Node
var desc_manager: ShopDescriptionManager
var current_price: float
var current_points: float
var real_equipment_diciontary: Dictionary
var upgrade: Control
var downgrade: Control
var purchase_sfx: AudioStreamPlayer2D
var refund_sfx: AudioStreamPlayer2D
var deny_sfx: AudioStreamPlayer2D
var back_button: Control

func initialize(parent_instance: Node):
	parent = parent_instance
	desc_manager = parent.shop_description_manager
	real_equipment_diciontary = Global.equipment_settings.equipments.duplicate(true)
	upgrade = parent.get_node("ItemInfo/HBoxContainer/upgrade_button/upgrade/CenterContainer/Button")
	downgrade = parent.get_node("ItemInfo/HBoxContainer/upgrade_button/down_grade/CenterContainer/Button")
	purchase_sfx = parent.get_node("ItemInfo/purchace")
	refund_sfx = parent.get_node("ItemInfo/refund")
	deny_sfx = parent.get_node("ItemInfo/deny")
	back_button = parent.get_node("back")
	upgrade.button_clicked.connect(purchase)
	downgrade.button_clicked.connect(refund)
	back_button.button_clicked.connect(update_equipment_settings)

func purchase():
	current_price = desc_manager.current_price
	current_points = parent.shop_description_manager.current_points
	if current_points < desc_manager.current_price:
		deny_sfx.play()
		return
	purchase_sfx.play()
	parent.shop_description_manager.current_points -= current_price
	update_level(1)
	desc_manager.update_text(true)

func refund():
	var equipment = desc_manager.current_equipment
	var temp = desc_manager.temp_equipment_stats[equipment]["level"]
	var real = real_equipment_diciontary[equipment]["level"]
	if temp == real:
		deny_sfx.play()
		return
	refund_sfx.play()
	parent.shop_description_manager.current_points += calculate_refund(desc_manager.temp_equipment_stats[equipment])
	update_level(-1)
	desc_manager.update_text(true)

func calculate_refund(equipment):
	var refund_value = desc_manager.calculate_current_value(equipment, ["price"])
	return refund_value

func update_level(increrment: int):
	var equipment = desc_manager.current_equipment
	desc_manager.temp_equipment_stats[equipment]["level"] += increrment
	
func update_equipment_settings():
	current_points = parent.shop_description_manager.current_points
	var temp = desc_manager.temp_equipment_stats
	Global.level_settings.curPoints = current_points
	Global.equipment_settings.equipments = temp
