extends Node3D
class_name combo_scene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var combo_minigame: ComboMinigame = $ui/ComboMinigame
@onready var fire_crackles: AudioStreamPlayer3D = $World/fire_crackles
@onready var ui: CanvasLayer = $ui

var level_scene : Level
var level_camera : Camera3D

@onready var points : int = 500
@onready var damage : int = 30

func _ready():
	combo_minigame.finished_lose.connect(lose)
	combo_minigame.finished_win.connect(win)
	fire_crackles.finished.connect(loop_sound)
	Transition.just_fade_in(1)
	await Transition.just_fade_finished
	animation_player.play("pan_camera")
	await animation_player.animation_finished
	start_mini_game()

func start_mini_game():
	combo_minigame.command_list = combo_minigame.generate_combo(5)
	animation_player.queue("fall_debris")

func loop_sound():
	fire_crackles.stream_paused = false
	fire_crackles.play()

func lose():
	if level_scene:
		level_camera.environment = null
		var player = level_scene.get_node("%player")
		Transition.just_fade(1)
		await Transition.just_fade_finished
		level_scene.process_mode = Node.PROCESS_MODE_INHERIT
		level_scene.visible = true
		visible = false
		ui.visible = false
		Transition.just_fade_in(1)
		player.camera_manager.apply_shake()
		player.audio_manager.rubble_audio.play()
		player.damage_animation_player.play("damage_animation")
		player.health -= damage
		queue_free()

func win():
	if level_scene:
		level_camera.environment = null
		var player = level_scene.get_node("%player")
		Transition.just_fade(1)
		await Transition.just_fade_finished
		level_scene.process_mode = Node.PROCESS_MODE_INHERIT
		level_scene.visible = true
		visible = false
		ui.visible = false
		Transition.just_fade_in(1)
		#player.camera_manager.apply_shake()
		player.audio_manager.rubble_audio.play()
		Global.level_settings.lvlPoints += points
		queue_free()
