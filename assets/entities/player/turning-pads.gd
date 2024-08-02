extends Control

@export var player : CharacterBody3D
@onready var left_panel := $"left-panel"
@onready var right_panel := $"right-panel"
@onready var left_panel_origin : Vector2 = Vector2(left_panel.custom_minimum_size.x,0)
@onready var right_panel_origin : Vector2 = Vector2.ZERO
#constant modes
var MODE_CUR_LEFT : float = 0
var MODE_CUR_MID : float = 1
var MODE_CUR_RIGHT : float = 2
var cursor_position : float = MODE_CUR_MID

func _physics_process(_delta):
	return
	match cursor_position:
		MODE_CUR_LEFT:
			var local_mouse_pos : Vector2 = Vector2(left_panel.get_local_mouse_position().x,0)
			var distance : float = left_panel_origin.distance_to(local_mouse_pos) / 2
			player.movement_manager.mvHorizontalRotation = distance 
		MODE_CUR_RIGHT:
			var local_mouse_pos : Vector2 = Vector2(right_panel.get_local_mouse_position().x,0)
			var distance : float = right_panel_origin.distance_to(local_mouse_pos) / 2
			player.movement_manager.mvHorizontalRotation = -distance
		MODE_CUR_MID:
			player.movement_manager.mvHorizontalRotation = 0

func _on_leftpanel_mouse_entered():
	cursor_position = MODE_CUR_LEFT

func _on_leftpanel_mouse_exited():
	cursor_position = MODE_CUR_MID

func _on_rightpanel_mouse_entered():
	cursor_position = MODE_CUR_RIGHT

func _on_rightpanel_mouse_exited():
	cursor_position = MODE_CUR_MID
