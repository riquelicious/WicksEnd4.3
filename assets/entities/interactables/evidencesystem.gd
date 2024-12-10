class_name EvidenceSystem
extends Node
var marked = false
var finished := false
# Called when the node enters the scene tree for the first time.
@onready var paper_piece = get_child(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if finished: return
	finished = get_child_count() == 0

func add_markers():
	if marked: return
	if is_instance_valid(paper_piece):
		paper_piece.objective_marker.add_objective_marker()
		paper_piece.objective_marker.show_marker = true
		marked = true
	
		
	# $%paper_piece.objective_marker.add_objective_marker()
	# $%paper_piece.objective_marker.show_marker = true
