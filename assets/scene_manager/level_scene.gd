extends Control

@onready var traffic: AudioStreamPlayer = $TextureRect/traffic
@onready var truck: AudioStreamPlayer = $TextureRect/truck
@onready var scene_manager: SceneManager = $SceneManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	truck.finished.connect(reset_truck)
	traffic.finished.connect(reset_traffic)
	scene_manager.text_manager.script_json = scene_manager.json_manager.load_json(Global.level_settings.level_selection)
	scene_manager.text_manager.init_text()
	scene_manager.scene_finished.connect(to_level)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_traffic():
	traffic.stream_paused = false
	traffic.play()
	pass

func reset_truck():
	truck.stream_paused = false
	truck.play()
	
func to_level():
	Transition.change_scene(FilePaths.levels[Global.level_settings.level_selection])
