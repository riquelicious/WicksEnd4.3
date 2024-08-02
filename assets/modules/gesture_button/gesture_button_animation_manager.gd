class_name GestureButtonAnimationManager
extends Node

var is_button_clicked
var parent : Node
var button_anim : AnimationPlayer
var current_anim : String

func initialize(parent_instance : Node):
	parent = parent_instance
	button_anim = parent.get_node("AnimationPlayer")
	button_anim.animation_changed.connect(current_animation.bind())
	button_anim.animation_finished.connect(finished_animation.bind())

func fade_in():
	if button_anim.is_playing(): return
	button_anim.clear_queue()
	button_anim.queue("fade_background")
	button_anim.queue("light_button_up")
	button_anim.queue("clicked")

func fade_out():
	button_anim.clear_queue()
	button_anim.play_backwards("fade_background")

func finished_animation(anim_name):
	if anim_name == "clicked":
		await fade_out()
		parent.emit_signal("button_activated")


func current_animation(_previous_anim,cur_anim):
	self.current_anim = cur_anim
