class_name Civilian
extends RigidBody3D

@onready var objective_marker_origin : Marker3D = $marker_origin

var objective_marker : ObjectiveMarker = ObjectiveMarker.new()
var civilain_manager : CivilianManager = CivilianManager.new() 
var audio_manager : CivilianAudioManager = CivilianAudioManager.new()

func _ready(): 
	objective_marker.initialize(self,objective_marker_origin) 
	civilain_manager.initialize(self)
	audio_manager.initialize(self)
	self.add_to_group("civilian")
