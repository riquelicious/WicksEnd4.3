class_name UpgradeShopDisplayManager extends Node

var parent: UpgradeShopMenu
var points_label: Label
var lerp_points: float
var previous_equipment_flag
var stat_labels: Array
var current_price: float
var price_label: Label
var level_label: RichTextLabel
var display_index: int
var display_container: Node3D
var display_animation_player: AnimationPlayer

enum STATS {
	DAMAGE,
	SWING,
	REPLENISH,
	DEPLETION,
	DAMAGE_RESIST
}
func _init(parent_instance: UpgradeShopMenu):
	self.parent = parent_instance

func _ready():
	stat_labels = parent.get_node("ColumnContainer/shopDisplays/ItemInfo/MessageBox/MarginContainer/StatColumn").get_children()
	price_label = parent.get_node("ColumnContainer/shopDisplays/ItemInfo/MessageBox/MarginContainer2/DamageResist/Value")
	level_label = parent.get_node("ColumnContainer/shopDisplays/ItemInfo/HBoxContainer/Control/RichTextLabel")
	points_label = parent.get_node("ColumnContainer/shopControls/controlContainers/PointLabel/Label")
	display_container = parent.get_node("ColumnContainer/shopDisplays/ItemInfo/HBoxContainer/DisplayWorld/container")
	display_animation_player = parent.get_node("ColumnContainer/shopDisplays/ItemInfo/HBoxContainer/Control/DisplayAnimation")
	assert(len(stat_labels) == len(STATS), "Enum STATS does not match with stat labels length!")
	assert(price_label, "Upgrade Shop Display Manager: Price Label not found!")
	assert(level_label, "Upgrade Shop Display Manager: Level Label not found!")
	update_text()
	update_points_display()

func _process(delta: float) -> void:
	update_points(delta)

func update_points_display():
	parent.available_points = Global.level_settings.curPoints
	points_label.text = str(parent.available_points)

func update_points(delta):
	if abs(parent.available_points - lerp_points) < 0.5:
		lerp_points = parent.available_points
		points_label.text = str(int(lerp_points))
		return
	lerp_points = lerp(lerp_points, parent.available_points, 10 * delta)
	points_label.text = str(int(lerp_points))
	return

func update_text(is_trading: bool = false):
	if parent.equipment_index == previous_equipment_flag and is_trading == false: return
	previous_equipment_flag = parent.equipment_index
	var key = parent.temporary_stats.keys()[parent.equipment_index]
	var equipment_stat = parent.temporary_stats[key]
	update_level(equipment_stat)
	update_price(equipment_stat)
	update_damage(equipment_stat)
	update_swing(equipment_stat)
	update_replenish(equipment_stat)
	update_depletion(equipment_stat)
	update_damage_resist(equipment_stat)
	
func update_level(equipment_stat: Dictionary):
	assert("level" in equipment_stat, "Equipment does not have level!")
	level_label.text = str("[b]LVL [color=orange]%d[/color][/b]" % equipment_stat["level"])

func update_price(equipment_stat: Dictionary):
	assert("price" in equipment_stat, "Equipment does not have price!")
	current_price = calculate_next_value(equipment_stat, ["price"])
	price_label.text = str(current_price)

func update_damage(equipment_stat: Dictionary):
	if not "damage" in equipment_stat:
		stat_labels[STATS.DAMAGE].visible = false
		return
	change_stat_text(equipment_stat, STATS.DAMAGE, ["damage"])
	
func update_swing(equipment_stat: Dictionary):
	if not "swing" in equipment_stat:
		stat_labels[STATS.SWING].visible = false
		return
	change_stat_text(equipment_stat, STATS.SWING, ["swing"])

func update_replenish(equipment_stat: Dictionary):
	if not "capacity" in equipment_stat:
		stat_labels[STATS.REPLENISH].visible = false
		return
	if not "increase" in equipment_stat["capacity"]:
		stat_labels[STATS.REPLENISH].visible = false
		return
	change_stat_text(equipment_stat, STATS.REPLENISH, ["capacity", "increase"], true)

func update_depletion(equipment_stat: Dictionary):
	if not "capacity" in equipment_stat:
		stat_labels[STATS.DEPLETION].visible = false
		return
	if not "decrease" in equipment_stat["capacity"]:
		stat_labels[STATS.DEPLETION].visible = false
		return
	change_stat_text(equipment_stat, STATS.DEPLETION, ["capacity", "decrease"], true)

func update_damage_resist(equipment_stat: Dictionary):
	if not "defense" in equipment_stat:
		stat_labels[STATS.DAMAGE_RESIST].visible = false
		return
	change_stat_text(equipment_stat, STATS.DAMAGE_RESIST, ["defense"])

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

func get_base_value(equipment: Dictionary, keys: Array) -> float:
	var stat = equipment
	for key in keys:
		stat = stat[key]
	return float(stat["base"])

func change_stat_text(equipment: Dictionary, stat: STATS, keys: Array, percentage: bool = false) -> void:
	var value = calculate_current_value(equipment, keys)
	var next_value = calculate_next_value(equipment, keys)
	if percentage:
		value = value / get_base_value(equipment, keys) * 100
		next_value = next_value / get_base_value(equipment, keys) * 100
	set_stat_value(stat, value, next_value, percentage)

func set_stat_value(stat: STATS, value: float, next_value: float, percentage: bool = false) -> void:
	var stat_label = stat_labels[stat]
	var value_label = stat_label.get_node("Value")
	var next_value_label = stat_label.get_node("NextValue")
	stat_label.visible = true
	if percentage:
		value_label.text = str(int(value)) + "%"
		next_value_label.text = str(int(next_value)) + "%"
		return
	value_label.text = str(value)
	next_value_label.text = str(next_value)

func update_display(index: int) -> void:
	if index == display_index: return
	display_index = index
	for child in display_container.get_children():
		child.visible = false
	display_container.get_child(index).visible = true
	display_animation_player.play("pop_up")
