class_name Pickups
extends StaticBody3D

@onready var objective_marker_origin: Marker3D = $marker_origin

var objective_marker: ObjectiveMarker = ObjectiveMarker.new()
var pickup_manager: PickupManager = PickupManager.new()

@export var piece_index: int = 0

signal picked_up

func remove_marker():
	objective_marker.remove_marker()

func _ready():
	objective_marker.initialize(self, objective_marker_origin)
	pickup_manager.initialize(self)
	self.add_to_group("pickup")
