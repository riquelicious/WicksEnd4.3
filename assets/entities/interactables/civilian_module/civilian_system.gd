class_name CivilianSystem
extends Node

@onready var civilians: Node = $civilians
var finished := false

func _process(delta: float) -> void:
	finished = civilians.get_child_count() == 0
	Global.level_settings.civilians_remaining = civilians.get_child_count()
