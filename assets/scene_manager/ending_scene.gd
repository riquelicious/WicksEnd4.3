extends Control

@onready var scene_manager: SceneManager = $SceneManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#truck.finished.connect(reset_truck)
	#traffic.finished.connect(reset_traffic)
	await $AnimationPlayer.animation_finished
	scene_manager.text_manager.script_json = scene_manager.json_manager.load_json(5)
	scene_manager.text_manager.init_text()
	scene_manager.scene_finished.connect(to_level)
	pass # Replace with function body.
	
#func 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func to_level():
	Global.gameplay_settings.from_level = true
	Transition.change_scene("res://game/main-menu/main_menu_level.tscn")
