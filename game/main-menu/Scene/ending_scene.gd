extends Control

var animation_player: AnimationPlayer
var cutscene_manager: CutSceneManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player = get_node_or_null("AnimationPlayer")
	cutscene_manager = get_node_or_null("CutSceneManager")
	assert(animation_player != null)
	assert(cutscene_manager != null)
	cutscene_manager.set_scene(CutSceneManager.SCENE.END,back_to_menu)
	await animation_player.animation_finished
	cutscene_manager.start_scene(0)

func back_to_menu():
	Transition.change_scene(FilePaths.MAIN_MENU)
