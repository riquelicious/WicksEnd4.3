extends CanvasLayer

@onready var anim : AnimationPlayer = $Transition/AnimationPlayer

var transitions : Dictionary = {
	"0" : [
		"fade_background_in",
		"fade_background_out"
	],
	"1" : [
		"switch_fade_in",
		"switch_fade_out"
	]
}



signal just_fade_finished
signal fade_finished

func _ready():
	anim.play_backwards("fade_background_in")
	await anim.animation_finished
	emit_signal("fade_finished")

func change_scene(scene_path: String, anim_index : int = 0):
	var fade_in = transitions[str(anim_index)][0]
	var fade_out = transitions[str(anim_index)][1]
	anim.play(fade_in) 
	await anim.animation_finished
	var _result = get_tree().change_scene_to_file(scene_path)
	anim.play(fade_out)
	await anim.animation_finished
	emit_signal("fade_finished")

func just_fade(anim_index : int = 0):
	var fade_in = transitions[str(anim_index)][0]
	anim.play(fade_in)
	await anim.animation_finished
	emit_signal("just_fade_finished")

func just_fade_in(anim_index : int = 0):
	var fade_out = transitions[str(anim_index)][1]
	anim.play(fade_out)
	await anim.animation_finished
	emit_signal("just_fade_finished")
