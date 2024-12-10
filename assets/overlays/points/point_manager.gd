class_name PointManager
extends Node

var player: PlayerEntity
var current_points := 0
# var label_foreground: Label
# var label_background: Label
var point_label: Label
var point_anim: AnimationPlayer
var popped := false
var point_sfx: AudioStreamPlayer2D
var point_node: Control

func _init(player_instance: PlayerEntity) -> void:
	self.player = player_instance

func _ready() -> void:
	point_node = player.get_node_or_null("PlayerUI/ScreenUI/TopUI/LeftPanel/Points")
	assert(point_node)
	point_label = point_node.get_node_or_null("PointLabel")
	point_sfx = point_node.get_node_or_null("PointSound")
	Global.level_settings.lvlPoints = 0
	point_label.text = str(current_points)
	# point_sfx = player.get_node("PlayerUI/on-screen-ui/ui/point_system_container/HBoxContainer/point_pop")
	# label_foreground = player.get_node("PlayerUI/on-screen-ui/ui/point_system_container/HBoxContainer/PlayerUI/foreground")
	# label_background = player.get_node("PlayerUI/on-screen-ui/ui/point_system_container/HBoxContainer/PlayerUI/background")
	# point_anim = player.get_node("PlayerUI/on-screen-ui/ui/point_system_container/HBoxContainer/point_animation")
	# label_background.text = str(current_points)
	# label_foreground.text = str(current_points)

func _process(delta: float) -> void:
	update_points(delta)

func update_points(delta):
	current_points = ceil(lerp(float(current_points), float(Global.level_settings.lvlPoints), delta * 10))
	# label_background.text = str(current_points)
	# label_foreground.text = str(current_points)
	point_label.text = str(current_points)
	if Global.level_settings.lvlPoints != current_points:
		if not popped:
			popped = true
			if not point_sfx.playing:
				point_sfx.play()
	else:
		popped = false
