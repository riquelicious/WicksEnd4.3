class_name SceneManager
extends CanvasLayer

##buttons
@export var script_index : int = 0
@onready var choices_button_container := $Control/choices_button_container

var json_manager : SceneJsonManager = SceneJsonManager.new()
var text_manager : SceneTextManager = SceneTextManager.new() 
var anim_manager : SceneAnimationManager = SceneAnimationManager.new()
var choice_manager : SceneChoiceManager = SceneChoiceManager.new()

func _ready():
	json_manager.initialize(self)
	choice_manager.initialize(self)
	anim_manager.initialize(self)
	text_manager.initialize(self)
