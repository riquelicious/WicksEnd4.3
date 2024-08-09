class_name ShopDescriptionManager
extends Node

var parent : Node
var points_label : Label
var points_label_shadow : Label
var description_label : RichTextLabel
var current_points : float
var current_price : float
var current_equipment : String
var lerp_points : float
var previous_equipment_flag
var temp_equipment_stats : Dictionary
var selected_equipment : Dictionary

var dict_reference : Dictionary = {
	0 : "nozzle",
	1 : "axe",
	2 : "extinguisher",
	3 : "blanket",
	4 : "gear"
}

func initialize(parent_instance : Node):
	parent = parent_instance
	points_label = parent.get_node("points/HBoxContainer/PanelContainer/foreground") 
	points_label_shadow = parent.get_node("points/HBoxContainer/PanelContainer/background")
	description_label = parent.get_node("ItemInfo/Panel/description")
	update()
	
func update():
	temp_equipment_stats = {}
	temp_equipment_stats = Global.equipment_settings.equipments.duplicate(true)
	init_points()
	
func init_points():
	current_points = Global.level_settings.lvlPoints
	points_label.text = str(current_points)
	points_label_shadow.text = str(current_points)
	lerp_points = current_points
	
func update_points(delta):
	if abs(current_points - lerp_points) < 0.5: 
		lerp_points = current_points
		points_label.text = str(int(lerp_points))
		points_label_shadow.text = str(int(lerp_points))
		return
	lerp_points = lerp(lerp_points, current_points, 10 * delta)
	points_label.text = str(int(lerp_points))
	points_label_shadow.text = str(int(lerp_points))


func update_text(bypass: bool = false):
	current_equipment = dict_reference[parent.shop_icon_manager.current_icon]
	if previous_equipment_flag == current_equipment and bypass == false: return
	previous_equipment_flag = current_equipment
	var equipment = temp_equipment_stats[current_equipment]
	selected_equipment = equipment
	var description = "[font_size=23]"
	description += get_level(equipment)
	description += get_price(equipment)
	description += "[/font_size][indent]"
	description += get_damage(equipment)
	description += get_swing(equipment)
	description += get_amount(equipment)
	description += get_defense(equipment)
	description += get_capacity(equipment)
	description += "[/indent]"
	description_label.bbcode_enabled = true
	description_label.text = description

func get_level(equipment) -> String:
	var text = ""
	text += "Level : [color=GRAY]"
	text += str(equipment["level"])
	text += "[/color] → [color=orange]"
	text += str(equipment["level"] + 1)
	text += "[/color]"
	return text

func get_price(equipment) -> String:
	if not "price" in equipment: return ""
	current_price = calculate_next_value(equipment,["price"])
	var text = ""
	text += "\n"
	text += "Price : [color=GRAY]"
	text += "[/color][color=orange][img=16x16]res://assets/images/ui/merit/merit.png[/img]"
	text += str(current_price)
	text +="[/color]"
	return text

func get_damage(equipment) -> String:
	if not "damage" in equipment: return ""
	var text = ""
	text += "Damage : [color=GRAY]"
	text += str(calculate_current_value(equipment,["damage"]))
	text +="[/color] → [color=orange]"
	text += str(calculate_next_value(equipment,["damage"])) 
	text += "[/color]"
	return text

func get_amount(equipment) -> String:
	if not "amount" in equipment: return ""
	var text = ""
	#text += "\n"
	text += "Amount : [color=GRAY]"
	text += str(calculate_current_value(equipment,["amount"]))
	text +="[/color] → [color=orange]"
	text += str(calculate_next_value(equipment,["amount"])) 
	text += "[/color]"
	return text

func get_defense(equipment) -> String:
	if not "defense" in equipment: return ""
	var text = ""
	#text += "\n"
	text += "Defense : [color=GRAY]"
	text += str(calculate_current_value(equipment,["defense"]))
	text +="[/color] → [color=orange]"
	text += str(calculate_next_value(equipment,["defense"])) 
	text += "[/color]"
	return text

func get_capacity(equipment) -> String:
	if not "capacity" in equipment: return ""
	var text = ""
	text += get_capacity_increase_rate(equipment)
	text += get_capacity_decrease_rate(equipment)
	return text

func get_capacity_increase_rate(equipment) -> String:
	if not "increase" in equipment["capacity"]: return ""
	var cur = calculate_current_value(equipment,["capacity","increase"])
	var next = calculate_next_value(equipment,["capacity","increase"])
	var cur_text = (cur / equipment["capacity"]["increase"]["base"]) * 100
	var next_text = (next / equipment["capacity"]["increase"]["base"]) * 100
	var text = ""
	text += "\n"
	text += "Replenish Rate : [color=GRAY]"
	text += str(cur_text)
	text +="%[/color] → [color=orange]"
	text += str(next_text) 
	text += "%[/color]"
	return text

func get_capacity_decrease_rate(equipment) -> String:
	if not "decrease" in equipment["capacity"]: return ""
	var cur = calculate_current_value(equipment,["capacity","decrease"])
	var next = calculate_next_value(equipment,["capacity","decrease"])
	var cur_text = (cur / equipment["capacity"]["decrease"]["base"]) * 100
	var next_text = (next / equipment["capacity"]["decrease"]["base"]) * 100
	var text = ""
	text += "\n"
	text += "Depletion Rate : [color=GRAY]"
	text += str(cur_text)
	text +="%[/color] → [color=orange]"
	text += str(next_text) 
	text += "%[/color]"
	return text
	
func get_swing(equipment) -> String:
	if not "swing" in equipment: return ""
	var text = ""
	text += "\n"
	text += "Swing Speed : [color=GRAY]"
	text += str(calculate_current_value(equipment,["swing"]))
	text +="%[/color] → [color=orange]"
	text += str(calculate_next_value(equipment,["swing"])) 
	text += "%[/color]"
	return text

func calculate_current_value(equipment : Dictionary,keys: Array):
	var stat = equipment
	for key in keys:
		stat = stat[key]
	var level = float(equipment["level"] - 1.0)
	var base = float(stat["base"])
	var multiplier = float(stat["multiplier"])
	return (base + ((base * multiplier) * level))


func calculate_next_value(equipment : Dictionary,keys: Array):
	var stat = equipment
	for key in keys:
		stat = stat[key]
	var level = float(equipment["level"] )
	var base = float(stat["base"])
	var multiplier = float(stat["multiplier"])
	return (base + ((base * multiplier) * level))
