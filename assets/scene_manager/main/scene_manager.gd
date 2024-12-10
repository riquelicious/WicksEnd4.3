class_name CutSceneManager extends Control

var startup_timer: Timer = Timer.new()
var json_manager: SceneJsonManager = SceneJsonManager.new(self)
var text_manager: SceneDialogueManager = SceneDialogueManager.new(self)
var choice_manager: CutSceneChoiceManager = CutSceneChoiceManager.new(self)
var callback: Callable

var choices_list: Array
var started: bool = false
enum SCENE {
	LEVEL1,
	LEVEL2,
	LEVEL3,
	LEVEL4,
	NOTE_FINISH,
	END
}

func _ready() -> void:
	assert(len(SCENE) == FilePaths.script_file_list.size(), "Number of Scenes does not match number of script files")
	text_manager._ready()
	choice_manager._ready()
	self.add_child(startup_timer)
	self.startup_timer.one_shot = true
	#assert(text_manager.script_json != null, "Script Json is null")

func _process(delta):
	if not started: return
	choice_manager._process(delta)

func set_scene(scene: SCENE, c = null) -> void:
	callback = c
	text_manager.script_json = json_manager.load_json(scene)

func start_scene(miliseconds: float) -> void:
	startup_timer.start(miliseconds)
	started = true
	await startup_timer.timeout
	text_manager.dialogue_anim.play("ShowBox")
	await text_manager.dialogue_anim.animation_finished
	text_manager.update_text()
