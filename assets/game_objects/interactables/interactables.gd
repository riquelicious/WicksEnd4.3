class_name interactables
extends StaticBody3D

@onready var objective_marker_origin : Marker3D = $marker_origin
@onready var camera_marker := $camera_position

var objective_marker : ObjectiveMarker = ObjectiveMarker.new()
var positioner : Positioner = Positioner.new()

func _ready():
	objective_marker.initialize(self,objective_marker_origin)
	positioner.initialize(self, camera_marker)
	self.add_to_group("interactable")


func _process(delta):
	positioner.position_camera(delta)
	
