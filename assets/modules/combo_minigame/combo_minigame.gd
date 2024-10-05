class_name ComboMinigame
extends Control

@onready var command_container := $CenterContainer/gesture_command_container
@onready var combo_countdown := $combo_countdown
@onready var countdown_bar = $countdown_bar
@onready var combo_node_path: String = FilePaths.combo_node_path
@onready var color_rect: ColorRect = $ColorRect

var command_list := []
var index := 0
var combo_countdown_duration := 0
var cn_is_expandable := true
var cn_min_size := 80
var min_percommand_duration := 2.5
var combo_achieved = false
var combo_inistialied := false
func _ready():
	color_rect.visible = false
	combo_countdown.connect("timeout", self._command_failed)
	#command_list = _generate_combo(5)

signal finished_win
signal finished_lose

func generate_combo(combo_amount):
	var command_array := []
	var previous_index: int = 0
	combo_countdown_duration = combo_amount * min_percommand_duration
	countdown_bar.max_value = combo_countdown_duration
	while combo_amount > 0:
		var rand_index := randi() % (len(Global.gesture_settings.gesture_list) - 1)
		rand_index += 1
		if rand_index != previous_index:
			command_array.append(Global.gesture_settings.gesture_list[rand_index])
			_add_combo_node(rand_index)
			previous_index = rand_index
			combo_amount -= 1
	combo_countdown.start(combo_countdown_duration)
	combo_inistialied = true
	return command_array

func _add_combo_node(image_index):
	var node: Resource = load(combo_node_path)
	var node_instance: TextureRect = node.instantiate()
	node_instance.expand = cn_is_expandable
	node_instance.custom_minimum_size = Vector2(cn_min_size, cn_min_size)
	node_instance.texture = FilePaths.gesture_icons[image_index]
	command_container.add_child(node_instance)

func _check_combo():
	if not combo_inistialied: return
	if combo_achieved: return
	if not command_list.size() > index:
		_command_succeed()
		combo_achieved = true
		return
	if Global.gesture_settings.gesture == command_list[index]:
		var node_index = command_container.get_child(index)
		node_index.combo_animation.play("activate")
		index += 1
		
func _command_succeed():
	print("congrats")
	emit_signal("finished_win")

func _command_failed():
	print("failed")
	emit_signal("finished_lose")
	color_rect.visible = true
	
		
func _process(_delta):
	_check_combo()
	countdown_bar.value = combo_countdown.time_left
	pass
