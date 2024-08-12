class_name PickablesSystem
extends Node
@onready var staircase: Area3D = $makeshift_staircase/staircase
@onready var pickups: Node = $pickups
var markers_added := false
var markers_added2 := false
var finished := false

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if finished: return
	staircase.picked_up = pickups.get_child_count() == 0
	finished = staircase.finished

func add_markers():
	if markers_added: return
	markers_added = true
	for p in $pickups.get_children():
		p.objective_marker.add_objective_marker()
		p.objective_marker.show_marker = true

func add_markers2():
	if markers_added2: return
	markers_added2 = true
	$makeshift_staircase/staircase.objective_marker.add_objective_marker()
	$makeshift_staircase/staircase.objective_marker.show_marker = true
