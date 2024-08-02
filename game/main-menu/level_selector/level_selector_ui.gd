extends Control

@onready var evidence: GestureButton = $"ui/Gesture Buttons/Evidence"
@onready var upgrade: GestureButton = $"ui/Gesture Buttons/Upgrade"
@onready var back: GestureButton = $"ui/Gesture Buttons/Back"

func _ready():
	evidence.button_gesture = GlobalControls.lsEvidence
	upgrade.button_gesture = GlobalControls.lsUpgrade
	back.button_gesture = GlobalControls.lsBack
	evidence.reinitialize()
	upgrade.reinitialize()
	back.reinitialize()
