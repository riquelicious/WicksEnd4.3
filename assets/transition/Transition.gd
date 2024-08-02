extends CanvasLayer

@onready var anim : AnimationPlayer = $Transition/AnimationPlayer

signal just_fade_finished

func _ready():
	anim.play_backwards("fade_background")

func change_scene(scene_path: String):
	anim.play("fade_background") 
	await anim.animation_finished
	var _result = get_tree().change_scene_to_file(scene_path)
	anim.play_backwards("fade_background")

func just_fade():
	anim.play("fade_background")
	await anim.animation_finished
	emit_signal("just_fade_finished")

func just_fade_in():
	anim.play_backwards("fade_background")
