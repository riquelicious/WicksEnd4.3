class_name JigsawManager
extends Node

var parent : Control
var piece_container : Panel
var distance : float = 30.0

func initialize(parent_instance : Control):
	parent = parent_instance
	piece_container = parent.get_node("jigsaw_container")

func check_all_pieces(delta):
	for piece in piece_container.get_children():
		if piece is TextureRect:
			if piece_container.get_rect().encloses(piece.get_global_rect()):
				snap_pieces(delta)

func snap_pieces(delta):
	for piece in piece_container.get_children():
		if not piece is TextureRect: return
		if piece.position.distance_to(parent.piece_positions[piece.name]) < distance:
			piece.position = lerp(piece.position, parent.piece_positions[piece.name], 10 * delta)
