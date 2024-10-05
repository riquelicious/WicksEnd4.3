class_name CrosshairManager extends Node

var player: PlayerEntity
var parent: GUI
var crosshair: Control
var current_index = 9
func _init(parent_instance: GUI):
	self.parent = parent_instance
	self.player = self.parent.player

func _ready() -> void:
	crosshair = parent.get_node_or_null("UICanvas/crosshair")

func check_visibility():
	crosshair.visible = !player.is_occupied()

func _process(delta: float) -> void:
	check_visibility()

func change_cursor(cursor_index: int) -> void:
	if cursor_index == current_index: return
	current_index = cursor_index
	parent.uiAnimation.play("cursor_transition")
	await parent.uiAnimation.animation_finished
	crosshair.texture = FilePaths.cursor_images[cursor_index]
	parent.uiAnimation.play_backwards("cursor_transition")
