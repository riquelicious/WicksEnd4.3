extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BGM.change_bgm("res://assets/audio/BGM/ThreeCandles.mp3")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	Transition.change_scene("res://game/main-menu/main_menu_level.tscn")
