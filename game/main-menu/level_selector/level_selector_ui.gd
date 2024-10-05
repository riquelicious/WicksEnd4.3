extends Control

@onready var evidence := $"ui/Gesture Buttons/Evidence"
@onready var upgrade := $"ui/Gesture Buttons/Upgrade"
@onready var back := $"ui/Gesture Buttons/Back"
@onready var image = $ui/image
@onready var label_play: Label = $"ui/image/button-label"

var backHoverButton: GestureHoldButton
var evidenceHoverButton: GestureHoldButton
var upgradeHoverButton: GestureHoldButton

func _ready():
	backHoverButton = GestureHoldButton.new(back, GlobalControls.back, LevelBack)
	evidenceHoverButton = GestureHoldButton.new(evidence, GlobalControls.evidence, LevelEvidence)
	upgradeHoverButton = GestureHoldButton.new(upgrade, GlobalControls.upgrade, LevelUpgrade)
	backHoverButton._ready()
	evidenceHoverButton._ready()
	upgradeHoverButton._ready()


func _process(delta: float) -> void:
	check_play_status()
	backHoverButton._process(delta)
	evidenceHoverButton._process(delta)
	upgradeHoverButton._process(delta)

func LevelBack():
	print_debug("Back")

func LevelEvidence():
	print_debug("Evidence")

func LevelUpgrade():
	print_debug("Upgrade")


func check_play_status():
	var level = Global.level_settings.level_selection
	var status = Global.level_settings.unlocked_levels[str(level)] != true
	image.disabled = status
