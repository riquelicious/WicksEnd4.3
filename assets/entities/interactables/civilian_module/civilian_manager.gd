class_name CivilianManager
extends Node3D

var parent: Node
var collision: CollisionShape3D
var player: PlayerEntity
var turn_to_player: bool = false
var civilian_mesh: Node3D
var animation_player: AnimationPlayer
var rotation_speed: float = 1.0

func initialize(parent_instance: Node):
	parent = parent_instance
	player = parent.get_node("%player")
	collision = parent.get_node("wall_collision")
	civilian_mesh = parent.get_node("civilian_mesh")
	animation_player = civilian_mesh.get_node("AnimationPlayer")
	
func pickup():
	animation_player.play("stand")
	await animation_player.animation_finished
	parent.visible = false
	animation_player.play_backwards("stand")
	parent.set_collision_layer_value(1, false)

func drop(pos: Vector3):
	parent.visible = true
	parent.set_collision_layer_value(1, true)
	pos.y += 1.5
	parent.global_transform.origin = pos
	parent.rotation = Vector3.ZERO
