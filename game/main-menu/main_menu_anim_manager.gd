class_name MenuAnimationManager
extends Node

var parent : Node
var ui_anim : AnimationPlayer
var ui_container : Control
var level_select : Control
var level_anim : AnimationPlayer

func initialize(parent_instance : Node):
	parent = parent_instance
	ui_container = parent.get_node("UI")
	ui_anim = ui_container.get_node("AnimationPlayer")
	level_select = parent.get_node("UI/level_selector")
	level_anim = level_select.get_node("AnimationPlayer")

func switch_ui(index : int):
	var child = ui_container.get_child(index)
	if child is Control:
		ui_anim.play("fade")
		await ui_anim.animation_finished
		for c in ui_container.get_children():
			if c is Control:
				c.visible = false
				c.process_mode = Node.PROCESS_MODE_DISABLED
		child.visible = true
		child.process_mode = Node.PROCESS_MODE_INHERIT
		parent.camera_manager.update_position(index)
		if child.name == "level-selector-ui" or child.name == "level_selector":
			level_anim.play("RESET")
		await parent.camera_manager.camera_movement_finished
		ui_anim.play_backwards("fade")
		await ui_anim.animation_finished
		if child.name == "level-selector-ui" or child.name == "level_selector":
			level_anim.play("fade")

func switch_level(index : int):
	var child = ui_container.get_child(1)
	ui_anim.play("fade")
	child.mouse_filter = 2 
	await ui_anim.animation_finished
	level_anim.play("RESET")
	parent.camera_manager.update_level(index)
	await parent.camera_manager.camera_movement_finished
	ui_anim.play_backwards("fade")
	await ui_anim.animation_finished
	level_anim.play("fade")
	child.mouse_filter = 0
