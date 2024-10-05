class_name MarkerManager extends Control

var objective_module: PackedScene
var gui: GUI
var player: PlayerEntity
var container: Control

func _init(gui_instance: GUI) -> void:
	self.gui = gui_instance
	self.player = self.gui.player

func _ready() -> void:
	container = gui.get_node_or_null("UICanvas/ObjectiveMarkers")
	objective_module = FilePaths.uiObjectiveMarker

func add_3d_marker(target: Node3D):
	if container == null:
		print_debug("container is null")
		return
	var objective_instance = objective_module.instantiate()
	objective_instance.marker_target = target
	container.add_child(objective_instance)
	container.move_child(objective_instance, 0)
	return objective_instance.get_instance_id()
