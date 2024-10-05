extends Node

enum gestures {
	none,
	closed_fist,
	open_palm,
	pointing_up,
	thumb_down,
	thumb_up,
	victory,
	iloveyou
}

var useEquipment := gestures.victory
var walk := gestures.closed_fist
var interact := gestures.thumb_up
var evidence := gestures.iloveyou
var upgrade := gestures.thumb_up
var back := gestures.thumb_down
var valve := gestures.closed_fist
var jigsaw := gestures.closed_fist
var inventory := gestures.thumb_down

var upgradeShopControls := [
	gestures.pointing_up,
	gestures.thumb_down,
	gestures.thumb_up,
	gestures.victory
]

var dialogueContols := [
	gestures.pointing_up,
	gestures.thumb_down,
	gestures.thumb_up,
	gestures.victory
]

var inventoryControls := [
	gestures.pointing_up,
	gestures.victory,
	gestures.iloveyou
]

# @onready var eqAim: String = Global.gesture_settings.gesture_list[6]
# @onready var eqAxeSwing: String = Global.gesture_settings.gesture_list[6]

# @onready var mvWalk: String = Global.gesture_settings.gesture_list[1]
# @onready var mvInteract: String = Global.gesture_settings.gesture_list[5]
# @onready var lsEvidence: String = Global.gesture_settings.gesture_list[7]
# @onready var lsUpgrade: String = Global.gesture_settings.gesture_list[5]
# @onready var lsBack: String = Global.gesture_settings.gesture_list[4]
# @onready var mgValve: String = Global.gesture_settings.gesture_list[1]
# @onready var mgJigsaw: String = Global.gesture_settings.gesture_list[1]
# @onready var uiInventory: String = Global.gesture_settings.gesture_list[4]

# var usControls: Array = [
# 	Global.gesture_settings.gesture_list[3],
# 	Global.gesture_settings.gesture_list[4],
# 	Global.gesture_settings.gesture_list[5],
# 	Global.gesture_settings.gesture_list[6],
# ]


# var dlControls: Array = [
# 	Global.gesture_settings.gesture_list[3],
# 	Global.gesture_settings.gesture_list[4],
# 	Global.gesture_settings.gesture_list[5],
# 	Global.gesture_settings.gesture_list[6]
# ]

# var invControls: Array = [
# 	Global.gesture_settings.gesture_list[3], # nozzle
# 	Global.gesture_settings.gesture_list[6], # axe
# 	Global.gesture_settings.gesture_list[7] # extinguisher
# ]
