extends Control

@onready var evidence: GestureButton = $"ui/Gesture Buttons/Evidence"
@onready var upgrade: GestureButton = $"ui/Gesture Buttons/Upgrade"
@onready var back: GestureButton = $"ui/Gesture Buttons/Back"
@onready var image = $ui/image
@onready var label_play : Label = $"ui/image/button-label"

func _ready():
	evidence.button_gesture = GlobalControls.lsEvidence
	upgrade.button_gesture = GlobalControls.lsUpgrade
	back.button_gesture = GlobalControls.lsBack
	evidence.reinitialize()
	upgrade.reinitialize()
	back.reinitialize()

func _process(delta: float) -> void:
	check_play_status()

func check_play_status():
	var level =  Global.level_settings.level_selection
	var status = Global.level_settings.unlocked_levels[str(level)] != true
	image.disabled = status
