class_name DebrisAreaManager
extends Node 

var parent : Node
var combo_minigame : PackedScene
var cam_env : Resource 
var initiated := false
var timer : Timer
var level_process
var level_camera 
var warning_audio : AudioStreamPlayer3D

func initialize(parent_instance : Node):
	parent = parent_instance
	combo_minigame = FilePaths.combo_minigame
	cam_env = FilePaths.bw_cam_env
	parent.body_entered.connect(body_entered.bind())
	warning_audio = parent.get_node("warning_audio")

func body_entered(body):
	if initiated: return
	if body.name == "player":
		initiated = true
		add_timer()

func add_minigame():
	Transition.just_fade(1)
	await Transition.just_fade_finished
	level_process.visible = false
	var scene = combo_minigame.instantiate()
	parent.get_tree().root.add_child(scene)
	scene.level_scene = level_process
	scene.level_camera = level_camera



func pause_background():
	var main_process = parent.get_tree().root.get_children()
	for process in main_process:
		if process is Level:
			process.process_mode = Node.PROCESS_MODE_DISABLED
			return process

func add_timer():
	level_camera = parent.get_viewport().get_camera_3d()
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(add_minigame)
	parent.get_tree().root.add_child(timer)
	timer.start(1)
	warning_audio.play()
	level_camera.environment = cam_env
	level_process = pause_background()
