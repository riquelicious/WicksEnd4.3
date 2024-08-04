class_name ComboAreaManager
extends Node

var parent : Node
var combo_minigame : PackedScene = preload("res://assets/debris/debris_scene.tscn")
var level_scene : Level

func initialize(parent_instance : Node):
	parent = parent_instance
	parent.body_entered.connect(body_entered.bind())

func body_entered(body):
	if body.name == "player":
		Transition.just_fade(1)
		await Transition.just_fade_finished
		var scene = combo_minigame.instantiate()
		parent.get_tree().root.add_child(scene)
		pause_background()

func pause_background():
	var main_process = parent.get_tree().root.get_children()
	for process in main_process:
		if process is Level:
			process.visible = false
			process.process_mode = Node.PROCESS_MODE_DISABLED

