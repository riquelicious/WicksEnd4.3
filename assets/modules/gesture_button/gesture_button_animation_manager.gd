class_name GestureHoldAnimation
extends Node

var is_button_clicked
var parent: GestureHoldButton
var buttonAnimationPlayer: AnimationPlayer
var current_anim: String

func _init(parent_instance: GestureHoldButton):
	self.parent = parent_instance

func _ready() -> void:
	buttonAnimationPlayer = parent.buttonNode.get_node_or_null("AnimationPlayer")
	assert(buttonAnimationPlayer != null)
	buttonAnimationPlayer.animation_changed.connect(current_animation.bind())
	buttonAnimationPlayer.animation_finished.connect(finished_animation.bind())

func fade_in():
	if buttonAnimationPlayer.is_playing(): return
	buttonAnimationPlayer.clear_queue()
	buttonAnimationPlayer.queue("fade_background")
	buttonAnimationPlayer.queue("light_button_up")
	buttonAnimationPlayer.queue("clicked")

func fade_out():
	buttonAnimationPlayer.clear_queue()
	buttonAnimationPlayer.play_backwards("fade_background")

func finished_animation(anim_name):
	if anim_name == "clicked":
		await fade_out()
		parent.callback.call()
		#parent.emit_signal("button_activated")


func current_animation(_previous_anim, cur_anim):
	self.current_anim = cur_anim
