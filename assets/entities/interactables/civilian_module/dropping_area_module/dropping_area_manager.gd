class_name DroppingAreaManager
extends Node

var parent : Node

func initialize(parent_instance : Node):
	parent = parent_instance
	parent.body_entered.connect(dropped.bind())

func dropped(body):
	if body is Civilian:
		body.queue_free()
		Global.level_settings.lvlPoints += parent.points_to_add
	
