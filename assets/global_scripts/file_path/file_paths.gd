extends Node

var combo_node_path = "res://assets/modules/combo_minigame/combo_node.tscn"

var levels = [
	"res://game/levels/level1/level-1.tscn",
	"res://game/levels/level2/level-2.tscn",
	"res://game/levels/level3/level-3.tscn",
	"res://game/levels/level4/level-4.tscn",
]

var cursor_images = [
	preload("res://assets/images/cursor_gestures/arrow.png"),
	preload("res://assets/images/cursor_gestures/fist.png"),
	preload("res://assets/images/cursor_gestures/palm.png"),
	preload("res://assets/images/cursor_gestures/point_up.png"),
	preload("res://assets/images/cursor_gestures/thumbs_down.png"),
	preload("res://assets/images/cursor_gestures/thumbs_up.png"),
	preload("res://assets/images/cursor_gestures/victory.png"),
	preload("res://assets/images/cursor_gestures/iloveyou.png"),
	preload("res://assets/images/cursor_gestures/crosshair.png")
]

var gesture_icons = [
	preload("res://assets/images/cursor_gestures/arrow.png"),
	preload("res://assets/images/ui/gesture_icons/fist.png"),
	preload("res://assets/images/ui/gesture_icons/palm.png"),
	preload("res://assets/images/ui/gesture_icons/point.png"),
	preload("res://assets/images/ui/gesture_icons/thumbs_down.png"),
	preload("res://assets/images/ui/gesture_icons/thumbs_up.png"),
	preload("res://assets/images/ui/gesture_icons/victory.png"),
	preload("res://assets/images/ui/gesture_icons/iloveyou.png")

]

var foot_step_sounds := [
	"res://assets/audio/sfx/foot_steps/foot_step-01.ogg",
	"res://assets/audio/sfx/foot_steps/foot_step-02.ogg",
	"res://assets/audio/sfx/foot_steps/foot_step-03.ogg",
	"res://assets/audio/sfx/foot_steps/foot_step-04.ogg",
	"res://assets/audio/sfx/foot_steps/foot_step-05.ogg"
]

var uiObjectiveMarker := preload("res://assets/modules/3d/floating_ui/objective.tscn")

var script_file_list := [
	"res://assets/script/script001.json",
	"res://assets/script/script002.json",
	"res://assets/script/script003.json",
	"res://assets/script/script004.json",
	"res://assets/script/script005.json",
	"res://assets/script/script006.json"
]

var fire_shader := preload("res://assets/shaders/fire_material.tres")
var fire_extinguished_fx := AudioStreamOggVorbis.load_from_file("res://assets/audio/sfx/fire/fire_wet.ogg")
var fire_kindled_fx := AudioStreamOggVorbis.load_from_file("res://assets/audio/sfx/fire/fire_woosh.ogg")

var combo_minigame: PackedScene = preload("res://assets/entities/debris/DebrisScene.tscn")
var bw_cam_env: Resource = preload("res://assets/environments/BW2.tres")
 
var cvHelpSounds: Array = [
	"res://assets/audio/sfx/civilian/help-01.ogg",
	"res://assets/audio/sfx/civilian/help-02.ogg",
	"res://assets/audio/sfx/civilian/help-03.ogg"
]

var level_scene: String = "res://assets/scene_manager/level_scene.tscn"


var polaroids = [
	preload("res://assets/images/ui/polaroid/apartment_image.png"),
	preload("res://assets/images/ui/polaroid/apartment_image.png"),
	preload("res://assets/images/ui/polaroid/apartment_image.png"),
	preload("res://assets/images/ui/polaroid/apartment_image.png"),
	preload("res://assets/images/ui/polaroid/black.png")
]

var lock_tex := preload("res://assets/images/ui/level_selector/lock.png")
var play_tex := preload("res://assets/images/ui/level_selector/play.png")


var upgrade_shop_sounds: Array = [
	"res://assets/audio/sfx/Upgrade_shop/deny.ogg",
	"res://assets/audio/sfx/Upgrade_shop/purchase.ogg",
	"res://assets/audio/sfx/Upgrade_shop/refund.ogg"
]