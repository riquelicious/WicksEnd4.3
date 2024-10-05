class_name HoverAnimationManager extends Node

var is_executed: bool = false
var is_button_clicked
var parent: HoverButton
var buttonAnimationPlayer: AnimationPlayer
var previous_animation: String
var is_looped: bool = true

func _init(parent_instance: HoverButton):
	self.parent = parent_instance

func _ready() -> void:
	buttonAnimationPlayer = parent.buttonNode.get_node_or_null("AnimationPlayer")
	assert(buttonAnimationPlayer != null)
	buttonAnimationPlayer.animation_changed.connect(current_animation.bind())
	buttonAnimationPlayer.animation_finished.connect(finished_animation.bind())

func fade_in():
	if buttonAnimationPlayer.is_playing():
		buttonAnimationPlayer.stop()
	buttonAnimationPlayer.clear_queue()
	buttonAnimationPlayer.queue("fade_in_background")
	buttonAnimationPlayer.queue("light_button_up")
	buttonAnimationPlayer.queue("clicked")

func fade_out():
	if is_button_clicked:
		return
	if buttonAnimationPlayer.is_playing():
		buttonAnimationPlayer.stop()
	buttonAnimationPlayer.clear_queue()
	buttonAnimationPlayer.play_backwards("fade_in_background")

func finished_animation(anim_name):
	if anim_name == "clicked":
		is_button_clicked = false
		if not parent.one_shot:
			is_looped = true
			print_debug("%s called at %s" % [parent.callback, parent.buttonNode.name])
			parent.callback.call()
		fade_out()
	elif anim_name == "fade_in_background" and previous_animation == "clicked":
		if parent.one_shot:
			print_debug("%s called at %s" % [parent.callback, parent.buttonNode.name])
			parent.callback.call()
	previous_animation = anim_name

func current_animation(_prev_anim, anim_name):
	if anim_name == "clicked":
		is_button_clicked = true
		is_executed = true
