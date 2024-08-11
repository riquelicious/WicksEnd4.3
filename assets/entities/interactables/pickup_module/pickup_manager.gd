class_name PickupManager
extends Node

var parent : Node
var anim : AnimationPlayer
func initialize(parent_instance : Node):
	parent = parent_instance
	anim = parent_instance.get_node("model/AnimationPlayer")

func pickup():
	if is_instance_valid(parent):
		anim.play("fade")
		await anim.animation_finished
		parent.emit_signal("picked_up")
		parent.queue_free()
