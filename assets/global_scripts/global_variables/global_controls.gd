extends Node

@onready var eqAim : String = Global.gesture_settings.gesture_list[6]
@onready var eqAxeSwing : String = Global.gesture_settings.gesture_list[7]
@onready var mvWalk : String = Global.gesture_settings.gesture_list[1]
@onready var mvInteract : String = Global.gesture_settings.gesture_list[5]
@onready var lsEvidence : String = Global.gesture_settings.gesture_list[7] 
@onready var lsUpgrade : String = Global.gesture_settings.gesture_list[5] 
@onready var lsBack : String = Global.gesture_settings.gesture_list[4] 
@onready var mgValve : String = Global.gesture_settings.gesture_list[1] 
@onready var mgJigsaw : String = Global.gesture_settings.gesture_list[1] 
@onready var uiInventory : String = Global.gesture_settings.gesture_list[4]

@onready var usControls : Array = [
	Global.gesture_settings.gesture_list[3],
	Global.gesture_settings.gesture_list[4],
	Global.gesture_settings.gesture_list[5],
	Global.gesture_settings.gesture_list[6],
]
@onready var dlControls : Array = [
	Global.gesture_settings.gesture_list[3],
	Global.gesture_settings.gesture_list[4],
	Global.gesture_settings.gesture_list[5],
	Global.gesture_settings.gesture_list[6]
]

@onready var invControls : Array = [
	Global.gesture_settings.gesture_list[3],
	Global.gesture_settings.gesture_list[6],
	Global.gesture_settings.gesture_list[7]
]
