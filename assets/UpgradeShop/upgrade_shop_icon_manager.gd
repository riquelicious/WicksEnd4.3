class_name ShopIconManager
extends Node

var parent: Node
var equipment_container: Node3D
var animation_player: AnimationPlayer
var current_icon

func initialize(parent_instance: Node):
	parent = parent_instance
	equipment_container = parent.get_node("ItemInfo/HBoxContainer/SubViewport/container")
	animation_player = parent.get_node("AnimationPlayer")
	update_icon(0)
	
func update_icon(index: int):
	if index == current_icon: return
	current_icon = index
	for child in equipment_container.get_children():
		child.visible = false
	equipment_container.get_child(index).visible = true
	animation_player.play_backwards("fade")
