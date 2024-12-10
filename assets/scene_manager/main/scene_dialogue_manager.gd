class_name SceneDialogueManager extends Node

signal choice_updated

var parent: CutSceneManager
var dialogue_title: RichTextLabel
var dialogue_text: RichTextLabel
var dialogue_anim: AnimationPlayer
var choices_anim: AnimationPlayer
var per_char_timer: Timer = Timer.new()
var per_dial_timer: Timer = Timer.new()
var start_delay_timer: Timer = Timer.new()
var script_json: Dictionary

var displayed_char_length: int = 0
var node_index := 0
var char_display_speed := 0.02
var current_text: String
var minimum_post_dialogue_pause_duration: float = 3.0
#var start_delay: float = 1.0
var prev_title: String
#var choices_list: Array
var nextNodeValue := 0

func _init(parent_instance: Node) -> void:
	self.parent = parent_instance


func _ready():
	parent.add_child(per_char_timer)
	parent.add_child(per_dial_timer)
	self.dialogue_title = parent.get_node_or_null("DialogueBox/Panel/VBoxContainer/Name")
	self.dialogue_text = parent.get_node_or_null("DialogueBox/Panel/VBoxContainer/Contents")
	self.dialogue_anim = parent.get_node_or_null("DialogueBox/DialogueAnimation")
	self.choices_anim = parent.get_node_or_null("VBoxContainer/ChoiceAnimation")
	assert(dialogue_anim)
	assert(choices_anim)
	assert(dialogue_text)
	assert(dialogue_title)
	per_char_timer.timeout.connect(increment_char)
	per_char_timer.one_shot = true
	per_dial_timer.timeout.connect(update_text)
	per_dial_timer.one_shot = true
	dialogue_text.text = ""
	dialogue_title.text = ""


func update_text():
	update_next_node()
	displayed_char_length = 0
	var index = str(node_index)
	if script_json.has(index):

		await set_dialogue_title(index)
		set_dialogue_text(index)
		fetch_choices(index)
		per_char_timer.start(char_display_speed)
	else:
		print_debug("Dialogue Exhausted")
		dialogue_anim.play_backwards("ShowBox")
		await dialogue_anim.animation_finished
		on_dialogue_finshed()

func update_next_node() -> void:
	if nextNodeValue == 0: # add 1 if no specific next node
		node_index += 1
	else:
		node_index = nextNodeValue
		nextNodeValue = 0


func set_dialogue_title(index: String) -> void:
	if not script_json[index].has("name"): return
	if prev_title == script_json[index]["name"]: return
	dialogue_anim.play_backwards("FadeName")
	await dialogue_anim.animation_finished
	dialogue_title.text = script_json[index]["name"].to_upper()
	prev_title = script_json[index]["name"]
	dialogue_anim.play("FadeName")
	await dialogue_anim.animation_finished

func set_dialogue_text(index: String) -> void:
	dialogue_text.visible_characters = 0
	current_text = script_json[index]["text"]
	dialogue_text.text = current_text # script_json[index]["text"]

func fetch_choices(index: String) -> void:
	parent.choices_list = script_json[index]["choices"]
	parent.choice_manager.list_choices()

func on_dialogue_finshed() -> void:
	if parent.callback != null:
		parent.callback.call()

func change_value(value: String) -> void:
	if not value: return
	nextNodeValue = int(value)
	emit_signal("choice_updated")

func increment_char() -> void:
	if displayed_char_length < len(current_text):
		if current_text[displayed_char_length] == "[":
			while current_text[displayed_char_length] != "]":
				if displayed_char_length < len(current_text) - 1:
					displayed_char_length += 1
				else:
					break
		else:
			displayed_char_length += 1
		#TODO audio
		dialogue_text.visible_characters = displayed_char_length
		per_char_timer.start(char_display_speed)
	else:
		next_dialogue()


func next_dialogue() -> void:
	var delay := minimum_post_dialogue_pause_duration
	if len(parent.choices_list) > 0:
		choices_anim.play("FadeChoices")
		await choices_anim.animation_finished
		await choice_updated
		delay = 0
		choices_anim.play_backwards("FadeChoices")
		await choices_anim.animation_finished
	per_dial_timer.start(delay)
