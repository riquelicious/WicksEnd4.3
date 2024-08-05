class_name DropArea
extends Node

@export var points_to_add := 1000

var area_manager : DroppingAreaManager = DroppingAreaManager.new()

func _ready() -> void:
	area_manager.initialize(self)
