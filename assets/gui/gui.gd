class_name GUI extends Control

var player: PlayerEntity
var crosshairManager: CrosshairManager
var markerManager: MarkerManager
var resourceBarManager: ResourceBarManager

@onready var uiAnimation: AnimationPlayer = get_node_or_null("UICanvas/UIAnimation")

func _ready() -> void:
	if get_parent() is PlayerEntity:
		player = self.get_parent()

	crosshairManager = CrosshairManager.new(self)
	markerManager = MarkerManager.new(self)
	resourceBarManager = ResourceBarManager.new(self)
	crosshairManager._ready()
	markerManager._ready()
	resourceBarManager._ready()

func _process(delta: float) -> void:
	crosshairManager._process(delta)
	resourceBarManager._process(delta)
