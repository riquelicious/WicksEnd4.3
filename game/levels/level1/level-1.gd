class_name Level
extends Node3D
@onready var player : CharacterBody3D = $%player
@onready var paper_piece : Pickups = $%paper_piece
@export var quests : Array[Node] = [

]
var current

func _ready() -> void:
	if paper_piece:
		paper_piece.picked_up.connect(update_piece)
	pass

func update_piece():
	var index = paper_piece.piece_index
	Global.gameplay_settings.evPiece[str(index)] = true

func _process(delta: float) -> void:
	var mission_string = ""
	if current != get_quest():
		current = get_quest()
	mission_string += "[center][color=orange][b]Mission[/b][/color]\n"
	mission_string += get_civilians(current)
	mission_string += pick(current)
	mission_string += valves(current)
	mission_string += get_fire(current)
	mission_string += evidence(current)
	#mission_string += "[/center]"
	Global.level_settings.quest_message = mission_string
func get_quest():
	for quest in quests:
		if not quest.finished:
			return quest
		


func get_civilians(quest_type) -> String:
	if quest_type is CivilianSystem:
		return "Find the civilians and carry them to the entrance.[/center]\n%s left." % Global.level_settings.civilians_remaining
	return ""

func pick(quest_type) -> String:
	if quest_type is PickablesSystem:
		
		return "'It seems like some of the stairs are broken.'
		\nCreate a makeshift staircase." 
	return ""

func valves(quest_type) -> String:
	if quest_type is SprinklerSystem:
		"The sprinklers are turned off.\n Let's turn the valves on"
	return ""
	
func get_fire(quest_type) -> String:
	if quest_type is FireSystem:
		return "There are still some fires around.\nLet’s extinguish them all.\nFire Extingished: %s"  % Global.level_settings.extinguished_percentage
	return ""

func evidence(quest_type) -> String:
	if quest_type is EvidenceSystem:
		return "The building is now relatively safe.\nLet's gather some evidence"
	return ""
