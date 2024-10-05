@tool
extends Control

@export var button_name: String = "Button"
@onready var button_label: Label = $"button-label"

func _ready() -> void:
	button_label.text = button_name
