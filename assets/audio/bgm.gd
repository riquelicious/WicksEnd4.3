extends AudioStreamPlayer
var target_volume:= 5.0
var current_volume := 0.0
var equal := true
var prev_vol

signal vol_lerp_finished

func _ready() -> void:
	#volume_db = linear_to_db(5)
	finished.connect(loop_audio)
	
func _process(delta: float) -> void:
	volume_lerp(delta)

	
func loop_audio():
	stream_paused = false
	play()

func volume_lerp(delta):
	if is_equal_approx(target_volume,current_volume): 
		if equal: return
		equal = true
		emit_signal("vol_lerp_finished")
		return
	equal = false
	current_volume = lerp(current_volume, target_volume, 20 * delta)
	if current_volume:
		volume_db = linear_to_db(int(current_volume > 0))

func change_bgm(path):
	prev_vol = current_volume
	target_volume = 0.0
	await vol_lerp_finished
	var music : AudioStream = load(path)
	stream = music
	play()
	target_volume = prev_vol
