class_name breakable
extends StaticBody3D

@onready var marker_origin : Marker3D = $marker_origin
@onready var player : CharacterBody3D = $%player

var objective_added = false
var health := 100
var objective_marker_id
var show_marker := true

func _ready():
	self.add_to_group("breakable")
	pass

func do_damage(damage):
	health -= damage
	_check_health()

func _add_objective_marker():
	if player:
		if !objective_added:
			var object : GUI = player.get_node("Control")
			if object:
				objective_marker_id = object.markerManager.add_3d_marker(self)
				objective_added = true

func _check_health():
	if health <= 0:
		if objective_added:
			instance_from_id(objective_marker_id).queue_free()
		queue_free()

func _process(_delta):
	if show_marker:
		_add_objective_marker()
	pass
