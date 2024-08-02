class_name SceneTextManager
extends Node

signal value_returned

var parent : Node
var text_name : RichTextLabel
var text_box : RichTextLabel
var per_char_timer : Timer
var per_dial_timer : Timer
var start_delay_timer : Timer
var script_json : Dictionary

var displayed_char_length : int = 0
var node_index := 0
var char_display_speed := 0.02
var current_text : String
var minimum_post_dialogue_pause_duration : float = 3.0
var start_delay : float = 1.0
var previous_name_value : String
var choices_list : Array
var nextNodeValue := 0

func initialize(parent_instance : Node):
	parent = parent_instance
	text_name = parent.get_node("Control/CenterContainer/DialogueBox/Rows/Name")
	text_box = parent.get_node("Control/CenterContainer/DialogueBox/Rows/TextBoxContainer/TextBox")
	per_char_timer = parent.get_node("per_char_timer")
	per_dial_timer = parent.get_node("per_dialogue_timer")
	start_delay_timer = parent.get_node("start_delay")
	#call_deferred("init_text")
	script_json = parent.json_manager.load_json(parent.script_index)
	init_text()
	

func init_text():
	text_name.bbcode_enabled = true
	text_box.bbcode_enabled = true
	per_char_timer.timeout.connect(increment_char)
	per_dial_timer.timeout.connect(update_text)
	start_delay_timer.timeout.connect(parent.anim_manager.fade_box)
	start_delay_timer.one_shot = true
	per_char_timer.one_shot = true
	per_dial_timer.one_shot = true
	#container.position.y = 896
	text_box.text = ""
	text_name.text = ""
	start_delay_timer.start(set_delay())
	await parent.anim_manager.animation_player.animation_finished
	update_text()


func update_text():
	if not script_json: return
	if nextNodeValue == 0:
		node_index += 1
	else:
		node_index = nextNodeValue
		nextNodeValue = 0
	displayed_char_length = 0
	var index = str(node_index)
	if script_json.has(index):
		#_get_name(index)
		await get_char_name(index)
		current_text = script_json[index]["text"]
		text_box.text = current_text
		text_box.visible_characters = displayed_char_length
		choices_list = script_json[index]["choices"]
		parent.choice_manager.list_choices()
		per_char_timer.start(char_display_speed)
	else:
		print_debug("Dialogue Exhausted")
		parent.anim_manager.fade_box(false)
		await parent.anim_manager.animation_player.animation_finished

	

func get_char_name(index):
	if not script_json[index].has("name"): return
	if previous_name_value == script_json[index]["name"]: return
	parent.anim_manager.animation_player.play_backwards("fade_name")
	await parent.anim_manager.animation_player.animation_finished
	text_name.text = script_json[index]["name"].to_upper() + ":"
	parent.anim_manager.animation_player.play("fade_name")
	previous_name_value = script_json[index]["name"]
	await parent.anim_manager.animation_player.animation_finished
			
func increment_char():
	if displayed_char_length < len(current_text):
		displayed_char_length += 1
		text_box.visible_characters = displayed_char_length
		per_char_timer.start(char_display_speed)
	else:
		var delay := minimum_post_dialogue_pause_duration
		if len(choices_list) > 0:
			await parent.anim_manager.fade_choices(true)
			await value_returned
			delay = 0
			await parent.anim_manager.fade_choices(false)
		per_dial_timer.start(delay)

func set_delay():
	return start_delay

func change_value(value):
	if not value:
		print(value)
		return
	print(value)
	nextNodeValue = int(value)
	emit_signal("value_returned")
