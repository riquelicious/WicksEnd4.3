class_name PickablesSystem
extends Node
@onready var staircase: Area3D = $makeshift_staircase/staircase
@onready var pickups: Node = $pickups

var finished := false
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	#print(staircase.picked_up, finished)
	staircase.picked_up = pickups.get_child_count() == 0
	finished = staircase.finished
