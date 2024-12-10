class_name ObjectiveMarker
extends Node

var player: PlayerA
var marker_origin: Marker3D
var show_marker := false
var parent: Node
var objective_added = false
var objective_marker_id

func initialize(object_instance: Node3D, marker_origin_instance: Marker3D):
	parent = object_instance
	player = parent.get_node("%player")
	marker_origin = marker_origin_instance
	 

func add_objective_marker():
	#if not show_marker: return
	if player:
		if !objective_added:
			if not player.is_node_ready():
				await player.ready
			var object = player.object_markers
			if object:
				objective_marker_id = object.add_3d_marker(marker_origin)
				objective_added = true
	
func remove_marker():
	if objective_marker_id:
		instance_from_id(objective_marker_id).queue_free()
