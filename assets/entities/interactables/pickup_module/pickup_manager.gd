class_name PickupManager
extends Node

var parent : Node

func initialize(parent_instance : Node):
	parent = parent_instance

func pickup():
	if is_instance_valid(parent):
		parent.queue_free()
