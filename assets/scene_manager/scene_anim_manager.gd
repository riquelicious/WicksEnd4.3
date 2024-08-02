class_name SceneAnimationManager
extends Node

var parent : Node
var animation_player : AnimationPlayer

func initialize(parent_instance : Node):
	parent = parent_instance
	animation_player = parent.get_node("AnimationPlayer")

func fade_box(fade: bool = true):
	if fade:
		animation_player.play("show_dialogue")
	else:
		animation_player.play("hide_dialogue")

func fade_choices(fade: bool):
	if fade:
		animation_player.play("fade_choices")
	else:
		animation_player.play_backwards("fade_choices")
	await animation_player.animation_finished
