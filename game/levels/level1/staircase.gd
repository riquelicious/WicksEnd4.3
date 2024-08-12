extends Area3D
@onready var player = $%player
@onready var stair_model: StaticBody3D = $CollisionShape3D/stair_model
@onready var objective_marker_origin : Marker3D = $marker_origin

var picked_up := false
var finished := false
var objective_marker : ObjectiveMarker = ObjectiveMarker.new()

func _ready() -> void:
	objective_marker.initialize(self,objective_marker_origin)
	body_entered.connect(_show.bind())
	#stair_model.visible = false
	#stair_model.set_collision_layer_value(1, false)

func _show(body):
	if not picked_up: return
	if finished: return
	if body == player:
		finished = true
		stair_model.visible = true
		stair_model.set_collision_layer_value(1, true)
