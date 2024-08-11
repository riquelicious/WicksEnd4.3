extends Control
@onready var quests: RichTextLabel = $Panel/quests



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	quests.text = Global.level_settings.quest_message
