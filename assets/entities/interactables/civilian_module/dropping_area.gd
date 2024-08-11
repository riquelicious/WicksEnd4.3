class_name DropArea
extends Node

@export var points_to_add := 1000

var area_manager : DroppingAreaManager = DroppingAreaManager.new()
var objective_marker : ObjectiveMarker = ObjectiveMarker.new()

func _ready() -> void:
	area_manager.initialize(self)
