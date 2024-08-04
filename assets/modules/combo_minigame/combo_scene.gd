extends Node3D
class_name combo_scene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var combo_minigame: ComboMinigame = $ui/ComboMinigame
@onready var fire_crackles: AudioStreamPlayer3D = $World/fire_crackles


func _ready():
	combo_minigame.finished_lose.connect(free_instance)
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

func free_instance():
	queue_free()
