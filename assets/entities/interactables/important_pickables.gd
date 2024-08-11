class_name PickablesSystem
extends Node

var finished := false
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	finished = get_child_count() == 0
