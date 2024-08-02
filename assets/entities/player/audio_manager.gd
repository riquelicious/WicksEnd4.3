class_name AudioManager
extends Node

var player : PlayerA
var foot_audio : AudioStreamPlayer3D
var previous_bob_position
var stepped := false

func initialize(player_instance: PlayerA):
	player = player_instance
	foot_audio = player.get_node("sounds/foot")

func play_footstep_sound():
	if not player.is_on_floor(): return
	var rand_index := randi() % len(FilePaths.foot_step_sounds)
	foot_audio.stream = AudioStreamOggVorbis.load_from_file(FilePaths.foot_step_sounds[rand_index - 1])
	foot_audio.stream_paused = false
	foot_audio.play()

func calculate_foot_dir(current_position):
	if previous_bob_position == null:
		previous_bob_position = current_position
	if current_position > previous_bob_position:
		stepped = false
	else:
		if not stepped:
			stepped = true
			play_footstep_sound()
	previous_bob_position = current_position
