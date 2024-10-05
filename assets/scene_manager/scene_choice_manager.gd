class_name SceneChoiceManager
extends Node

var parent : Node
var button_container : VBoxContainer
var values : Array

func initialize(parent_instance : Node):
	parent = parent_instance
	button_container = parent.get_node("Control/choices_button_container")
	values.resize(4)
	#fetch_choice_gestures()

func list_choices():
	for child in button_container.get_children():
		var anim = child.get_node("AnimationPlayer")
		child.visible = false
		anim.play("RESET")
	var index = 0 
	for choice in parent.text_manager.choices_list:
		var button_name = choice["text"]
		var button_value = choice["nextNode"]
		var button = button_container.get_child(index)
		button.get_node("CenterContainer/HBoxContainer/Label").text = button_name
		values[index] = button_value
		fetch_choice_values()
		button.visible = true
		index += 1

func fetch_choice_gestures():
	for i in button_container.get_child_count():
		var gesture = GlobalControls.dialogueContols[i]
		var child = button_container.get_child(i)
		child.button_gesture = gesture
		child.reinitialize()

func fetch_choice_values():
	for i in button_container.get_child_count():
		var child = button_container.get_child(i)
		if child.button_activated.is_connected(parent.text_manager.change_value):
			child.button_activated.disconnect(parent.text_manager.change_value)
		child.button_activated.connect(parent.text_manager.change_value.bind(values[i]))
	pass
