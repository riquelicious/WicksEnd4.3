extends Control

signal button_clicked

@export var delay := 0.0
@export var one_shot: bool = false
@onready var anim: AnimationPlayer = $AnimationPlayer
@export var disableable: bool = false
@onready var polaroid: TextureRect = $polaroid

var disabled: bool = false
var prev_status: bool = false
var label: Label

var previous_animation: String = ''
var is_button_clicked: bool = false
var is_hover: bool = false
var loop_animation_finished: bool = true
var is_executed: bool = false
var time := 0.0
@onready var icon_rect = $"play_rect"
var lock_tex := preload("res://assets/images/ui/level_selector/lock.png")
var play_tex := preload("res://assets/images/ui/level_selector/play.png")
var polaroids = [
	preload("res://assets/images/ui/polaroid/apartment_image.png"),
	preload("res://assets/images/ui/polaroid/apartment_image.png"),
	preload("res://assets/images/ui/polaroid/apartment_image.png"),
	preload("res://assets/images/ui/polaroid/apartment_image.png"),
	preload("res://assets/images/ui/polaroid/black.png")
]

func _ready():
	label = find_child("button-label")


func check_status():
	if disableable:
		if disabled:
			icon_rect.texture = lock_tex
			polaroid.texture = polaroids[4]
		else:
			icon_rect.texture = play_tex
			polaroid.texture = polaroids[Global.level_settings.level_selection]
			
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
	if not mouse_filter == 0: return
	var mouse_inside = get_global_rect().has_point(GlobalCursor.cursor_sprite.position)
	is_hover = mouse_inside
	if disabled: return
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
	else:
		if not loop_animation_finished:
			_fade_out()
			loop_animation_finished = true

# func _mouse_entered():
# 	if disabled: return
# 	print(disabled)
# 	is_hover = true
	
# func _mouse_exited():
# 	if disabled: return
# 	print(disabled)
# 	is_hover = false
# 	if not loop_animation_finished:
# 		_fade_out()
# 		loop_animation_finished = true

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
