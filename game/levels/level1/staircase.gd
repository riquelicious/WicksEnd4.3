extends Area3D
@onready var player = $%player
@onready var stair_model: Node3D = $stair_model

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stair_model.visible = false

func _show(body):
	if body == player:
		stair_model.visible = true
