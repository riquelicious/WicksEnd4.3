class_name AudioManager
extends Node

var player: PlayerEntity
var foot_audio: AudioStreamPlayer3D
var rubble_audio: AudioStreamPlayer3D
var water_audio: AudioStreamPlayer3D
var previous_bob_position
var stepped := false

func _init(player_instance: PlayerEntity):
	self.player = player_instance

func _ready():
	foot_audio = player.get_node("sounds/foot")
	rubble_audio = player.get_node("sounds/rubbles")
	#water_audio = player.get_node("sounds/pressurized_water")
	#water_audio.finished.connect(loop_audio.bind(water_audio))
	BGM.change_bgm("res://assets/audio/BGM/HurryTFup.mp3")
	#water_audio.volume_db = linear_to_db(Global.audio_settings.default_water_linear_volume)

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

func loop_audio(audio_instance: AudioStreamPlayer3D):
	audio_instance.stream_paused = false
	audio_instance.play()
