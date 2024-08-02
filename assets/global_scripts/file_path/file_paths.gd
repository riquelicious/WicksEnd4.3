extends Node

@onready var levels = [
	"res://game/levels/level1/level-1.tscn",
	"res://game/levels/level2/level-2.tscn",
	"res://game/levels/level3/level-3.tscn",
	"res://game/levels/level4/level-4.tscn",
	"res://game/levels/level5/level-5.tscn"
]

@onready var cursor_images = [
	preload("res://assets/images/cursor_gestures/arrow.png"),
	preload("res://assets/images/cursor_gestures/fist.png"),
	preload("res://assets/images/cursor_gestures/palm.png"),
	preload("res://assets/images/cursor_gestures/point_up.png"),
	preload("res://assets/images/cursor_gestures/thumbs_down.png"),
	preload("res://assets/images/cursor_gestures/thumbs_up.png"),
	preload("res://assets/images/cursor_gestures/victory.png"),
	preload("res://assets/images/cursor_gestures/iloveyou.png")
]

@onready var gesture_icons = [
	preload("res://assets/images/cursor_gestures/arrow.png"),
	preload("res://assets/images/ui/gesture_icons/fist.png"),
	preload("res://assets/images/ui/gesture_icons/palm.png"),
	preload("res://assets/images/ui/gesture_icons/point.png"),
	preload("res://assets/images/ui/gesture_icons/thumbs_down.png"),
	preload("res://assets/images/ui/gesture_icons/thumbs_up.png"),
	preload("res://assets/images/ui/gesture_icons/victory.png"),
	preload("res://assets/images/ui/gesture_icons/iloveyou.png")

]

@onready var foot_step_sounds := [
	"res://assets/sfx/foot_steps/foot_step-01.ogg",
	"res://assets/sfx/foot_steps/foot_step-02.ogg",
	"res://assets/sfx/foot_steps/foot_step-03.ogg",
	"res://assets/sfx/foot_steps/foot_step-04.ogg",
	"res://assets/sfx/foot_steps/foot_step-05.ogg"
]

@onready var uiObjectiveMarker := preload("res://assets/modules/3d/floating_ui/objective.tscn")

@onready var script_file_list := [
	"res://assets/script/script001.json"
]

@onready var fire_shader := preload("res://assets/shaders/fire_material.tres")
@onready var fire_extinguished_fx := AudioStreamOggVorbis.load_from_file("res://assets/sfx/fire/fire_wet.ogg")
@onready var fire_kindled_fx := AudioStreamOggVorbis.load_from_file("res://assets/sfx/fire/fire_woosh.ogg")
