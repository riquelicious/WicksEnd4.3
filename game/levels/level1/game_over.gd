extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#game_over()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over():
	var cam = get_viewport().get_camera_3d()
	cam.environment = FilePaths.bw_cam_env
	var main_process = get_tree().root.get_children()
	for process in main_process:
		if process is Level:
			process.process_mode = Node.PROCESS_MODE_DISABLED
			audio_stream_player.play()
			animation_player.play("fade")
			Global.gameplay_settings.from_level = true
			var index = $%paper_piece.piece_index
			Global.gameplay_settings.evPiece[str(index)] = true
			await animation_player.animation_finished
			Transition.change_scene("res://game/main-menu/main_menu_level.tscn")


func game_finished():
	var cam = get_viewport().get_camera_3d()
	cam.environment = FilePaths.bw_cam_env
	var main_process = get_tree().root.get_children()
	for process in main_process:
		if process is Level:
			process.process_mode = Node.PROCESS_MODE_DISABLED
			audio_stream_player_2.play()
			animation_player.play("fade_2")
			Global.gameplay_settings.from_level = true
			await animation_player.animation_finished
			Transition.change_scene("res://game/main-menu/main_menu_level.tscn")
			
