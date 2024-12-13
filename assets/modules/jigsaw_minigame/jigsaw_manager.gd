class_name JigsawManager
extends Node

var parent : Control
var piece_container : Panel
var distance : float = 30.0
var distance_threshold : float = 0.1
var animation_player : AnimationPlayer
var paper_texture : TextureRect
var paper_displayed : bool = false
var pieces : Dictionary
var finished : bool = false:
	get: 
		return finished
	set(value):
		display_paper(value)


func initialize(parent_instance : Control):
	parent = parent_instance
	animation_player = parent.get_node("AnimationPlayer")
	piece_container = parent.get_node("jigsaw_container")
	paper_texture = parent.get_node("paper")
	pieces = Global.gameplay_settings.evPiece
	check_status_unlocked()
	check_status_finished()

func update():
	pieces = Global.gameplay_settings.evPiece
	check_status_unlocked()
	check_status_finished()

func check_status_unlocked():
	for index in range(pieces.size() -1):
		print("piece no: " + str(index) + " is " + str(pieces[str(index)]))
		piece_container.get_child(index).visible = pieces[str(index)]

func check_status_finished():
	
	if Global.gameplay_settings.evFinished:
		display_paper(true)
		for piece in piece_container.get_children():
			piece.visible = false
			paper_texture.modulate = Color.WHITE


func check_all_pieces(delta):
	if Global.gameplay_settings.evFinished: return
	for piece in piece_container.get_children():
		if piece is TextureRect:
			if piece_container.get_rect().encloses(piece.get_global_rect()):
				finished = snap_pieces(delta)


func snap_pieces(delta) -> bool:
	var connected_piece : int = 0
	for piece in piece_container.get_children():
		if not piece is TextureRect: continue
		if piece.position.distance_to(parent.piece_positions[piece.name]) < distance:
			piece.position = lerp(piece.position, parent.piece_positions[piece.name], 10 * delta)
			var a = (piece.position - parent.piece_positions[piece.name]).length() < distance_threshold
			if a :
				piece.position = parent.piece_positions[piece.name]
				connected_piece += 1
		else:
			continue
	return connected_piece == 4

func display_paper(value : bool):
	if paper_displayed: return
	if value:
		paper_displayed = true
		Global.gameplay_settings.evFinished = true
		animation_player.play("fade")
		await animation_player.animation_finished
		animation_player.speed_scale = 0.3
		animation_player.queue("finished")
		await animation_player.animation_finished
		animation_player.speed_scale = 1.0
