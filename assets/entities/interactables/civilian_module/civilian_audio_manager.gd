class_name CivilianAudioManager
extends Node

var parent : Node
var sounds : Array
var delays : Array
var yell_timer : Timer
var yell_audio_streamer : AudioStreamPlayer3D

func initialize(parent_instance : Node):
	parent = parent_instance
	delays = Global.audio_settings.cvHelpDelays
	yell_audio_streamer = parent.get_node("yell_audio_streamer")
	yell_timer = parent.get_node("yell_timer")
	yell_timer.timeout.connect(on_timer_timeout)
	yell_timer.one_shot = true
	yell_timer.start(randomize_delay())
	get_audio()

func get_audio():
	for path in FilePaths.cvHelpSounds:
		var audio = AudioStreamOggVorbis.load_from_file(path)
		sounds.append(audio)

func randomize_delay() -> int:
	var index = (randi() % len(delays) - 1)
	return delays[index]

func randomize_sound() -> AudioStreamOggVorbis:
	var index = (randi() % len(sounds) - 1)
	return sounds[index]

func on_timer_timeout():
	if parent.visible == false: return
	var audio = randomize_sound()
	var delay = randomize_delay()
	yell_audio_streamer.stream = audio
	yell_audio_streamer.play()
	yell_timer.start(delay)