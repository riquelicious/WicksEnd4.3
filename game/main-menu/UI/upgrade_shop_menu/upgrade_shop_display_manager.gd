class_name UpgradeShopDisplayManager extends Node

var parent: UpgradeShopMenu
var points_label: Label
var description_label: RichTextLabel
var lerp_points: int
var previous_equipment_flag
var clvl: String = "gray"
var nclvl: String = "orange"

func _init(parent_instance: UpgradeShopMenu):
	self.parent = parent_instance

func _ready():
	points_label = parent.get_node_or_null("ColumnContainer/shopControls/controlContainers/PointLabel/Label")
	description_label = parent.get_node_or_null("ColumnContainer/shopDisplays/ItemInfo/MessageBox/MarginContainer/Description")
	assert(points_label, "Upgrade Shop Display Manager: Points Label not found!")
	assert(description_label, "Upgrade Shop Display Manager: Description Label not found!")
	update_text()

func update_points_display():
	parent.current_points = Global.level_settings.curPoints
	points_label.text = str(parent.current_points)

func update_points(delta):
	if lerp_points != parent.current_points:
		lerp_points = lerp(lerp_points, parent.current_points, 10 * delta)
		points_label.text = str(int(lerp_points))
		return
	lerp_points = parent.current_points
	points_label.text = str(int(lerp_points))


func update_text():
	if parent.equipment_index == previous_equipment_flag: return
	previous_equipment_flag = parent.equipment_index
	var key = parent.temporary_stats.keys()[parent.equipment_index]
	var equipment_stat = parent.temporary_stats[key]
	var level = get_level(equipment_stat)
	var price = get_price(equipment_stat)
	var description = (
	"%s\n%s" % [level, price])
	description_label.text = description

func get_level(equipment) -> String:
	var lvl = equipment["level"]
	return ("Level : [color=%s]%d[/color] → [color=%s]%d[/color]" % [clvl, lvl, nclvl, lvl + 1])

func get_price(equipment) -> String:
	var price = calculate_next_value(equipment, ["price"])
	var icon = "[img=16x16]res://assets/images/ui/merit/merit.png[/img]"
	return ("Price : %s[color=%s]%d[/color]" % [icon, nclvl, price])

func calculate_next_value(equipment: Dictionary, keys: Array):
	var stat = equipment
	for key in keys:
		stat = stat[key]
	var level = float(equipment["level"])
	var base = float(stat["base"])
	var multiplier = float(stat["multiplier"])
	return (base + ((base * multiplier) * level))

func calculate_current_value(equipment: Dictionary, keys: Array):
	var stat = equipment
	for key in keys:
		stat = stat[key]
	var level = float(equipment["level"] - 1.0)
	var base = float(stat["base"])
	var multiplier = float(stat["multiplier"])
	return (base + ((base * multiplier) * level))
