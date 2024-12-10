extends Node3D

@onready var cut_scene_manager: CutSceneManager = $CutSceneManager

func _ready() -> void:
	cut_scene_manager.set_scene(CutSceneManager.SCENE.LEVEL1, phew)
	cut_scene_manager.start_scene(1)
func phew():
	print("A")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
