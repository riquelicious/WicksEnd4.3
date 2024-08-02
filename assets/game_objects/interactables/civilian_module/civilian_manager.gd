class_name CivilianManager 
extends Node

var parent : Node
var collision : CollisionShape3D

func initialize(parent_instance : Node):
	parent = parent_instance
	collision = parent.get_node("wall_collision")

func pickup():
	parent.visible = false
	parent.set_collision_layer_value(1, false)

func drop(position: Vector3):
	parent.visible = true
	parent.set_collision_layer_value(1, true)
	position.y += 1.5
	parent.global_transform.origin = position
	parent.rotation = Vector3.ZERO
	
