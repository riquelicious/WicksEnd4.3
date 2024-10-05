class_name HoverButtona
extends Control

signal button_clicked

@export var delay := 0.0
@export var one_shot: bool = false
@onready var anim: AnimationPlayer = $AnimationPlayer
@export var disableable: bool = false
var disabled: bool = false
var prev_status: bool = false
var label: Label
#@onready var button_label : Label = $"button-label"

var previous_animation: String = ''
var is_button_clicked: bool = false
var is_hover: bool = false
var loop_animation_finished: bool = true
var is_executed: bool = false
var time := 0.0

func _ready():
	label = find_child("button-label")
	mouse_exited.connect(_mouse_exited)
	mouse_entered.connect(_mouse_entered)

func check_status():
	if prev_status == disabled: return
	prev_status = disabled
	if disableable:
		if disabled:
			label.modulate = Color(1.0, 1.0, 1.0, 0.5)
		else:
			label.modulate = Color.WHITE

func _fade_in():
	if anim.is_playing():
		anim.stop()
	anim.clear_queue()
	anim.queue("fade_in_background")
	anim.queue("light_button_up")
	anim.queue("clicked")

func _fade_out():
	if is_button_clicked:
		return
	if anim.is_playing():
		anim.stop()
	anim.clear_queue()
	anim.play_backwards("fade_in_background")

func _process(delta):
	check_status()
	if is_executed:
		if time < delay:
			time += delta
			return
	time = 0.0
	is_executed = false
	if is_hover:
		if loop_animation_finished:
			loop_animation_finished = false
			_fade_in()

func _mouse_entered():
	if disabled: return
	is_hover = true
	
func _mouse_exited():
	if disabled: return
	is_hover = false
	if not loop_animation_finished:
		_fade_out()
		loop_animation_finished = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "clicked":
		is_button_clicked = false
		if not one_shot:
			loop_animation_finished = true
			emit_signal("button_clicked")
		_fade_out()
	if anim_name == "fade_in_background" and previous_animation == "clicked":
		if one_shot:
			emit_signal("button_clicked")
	previous_animation = anim_name
	
func _on_animation_player_current_animation_changed(anim_name):
	if anim_name == "clicked":
		is_button_clicked = true
		is_executed = true
		#emit_signal("button_clicked")
