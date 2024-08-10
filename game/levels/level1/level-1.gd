class_name Level
extends Node3D
@onready var player : CharacterBody3D = $%player
@onready var paper_piece : Pickups = $%paper_piece


func _ready() -> void:
	if paper_piece:
		paper_piece.picked_up.connect(update_piece)
	pass

func update_piece():
	var index = paper_piece.piece_index
	Global.gameplay_settings.evPiece[str(index)] = true
