extends Control

var traffic: AudioStreamPlayer
var truck: AudioStreamPlayer
var cut_scene_manager: CutSceneManager

func _ready() -> void:
	traffic = get_node("TextureRect/traffic")
	truck = get_node("TextureRect/truck")
	cut_scene_manager = get_node("CutSceneManager")
	traffic.finished.connect(reset_traffic)
	truck.finished.connect(reset_truck)
	cut_scene_manager.set_scene(Global.level_settings.level_selection, to_level)
	cut_scene_manager.start_scene(1)

func reset_traffic():
	traffic.stream_paused = false
	traffic.play()
	pass

func reset_truck():
	truck.stream_paused = false
	truck.play()

func to_level():
	Transition.change_scene(FilePaths.levels[Global.level_settings.level_selection])
