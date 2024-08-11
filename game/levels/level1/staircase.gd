extends Area3D
@onready var player = $%player
@onready var stair_model: StaticBody3D = $CollisionShape3D/stair_model

var picked_up := false
var finished := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_show.bind())
	stair_model.visible = false
	stair_model.set_collision_layer_value(1, false)

func _show(body):
	if not picked_up: return
	if finished: return
	if body == player:
		finished = true
		stair_model.visible = true
		stair_model.set_collision_layer_value(1, true)
