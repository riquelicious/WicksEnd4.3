class_name EvidenceContainer extends Control


var parent: Control
var piece_container: Panel
var distance: float = 30.0
var distance_threshold: float = 0.1
var PuzzleAnimationPlayer: AnimationPlayer
var paper_texture: TextureRect
var paper_displayed: bool = false
var pieces: Dictionary
var finished: bool = false:
	get:
		return finished
	set(value):
		display_paper(value)


func _init(parent_instance: Control):
	self.parent = parent_instance


func _ready() -> void:
	PuzzleAnimationPlayer = parent.get_node("Puzzle/PuzzleAnimation")
	piece_container = parent.get_node("Puzzle/PieceContainer")
	paper_texture = parent.get_node("Puzzle/CompletePaper")
	update_piece_status()


func _process(delta: float) -> void:
	check_all_pieces(delta)

func update_piece_status() -> void:
	pieces = Global.gameplay_settings.evPiece
	if not check_status_finished():
		check_status_unlocked()

func check_status_unlocked() -> void:
	for index in range(pieces.size()):
		parent.pieces[index].piece_node.visible = pieces[str(index)]

func check_status_finished() -> bool:
	if Global.gameplay_settings.evFinished:
		display_paper(true)
		for piece in piece_container.get_children():
			piece.visible = false
			paper_texture.modulate = Color.WHITE
	return Global.gameplay_settings.evFinished

func check_all_pieces(delta) -> void:
	if Global.gameplay_settings.evFinished: return
	for piece in piece_container.get_children():
		if piece is TextureRect:
			if piece_container.get_global_rect().encloses(piece.get_global_rect()):
				finished = snap_pieces(delta)


func snap_pieces(delta) -> bool:
	var connected_piece: int = 0
	for piece: EvidencePiece in parent.pieces: # piece_container.get_children():
		if piece.piece_node.position.distance_to(parent.positions[piece.piece_index]) < distance:
			piece.piece_node.position = lerp(piece.piece_node.position, parent.positions[piece.piece_index], 10 * delta)
			var a = (piece.piece_node.position - parent.positions[piece.piece_index]).length() < distance_threshold
			if a:
				piece.piece_node.position = parent.positions[piece.piece_index]
				connected_piece += 1
		else:
			continue
	return connected_piece == 4

func display_paper(value: bool):
	if paper_displayed: return
	if value:
		paper_displayed = true
		PuzzleAnimationPlayer.play_backwards("NotesFade")
		await PuzzleAnimationPlayer.animation_finished
		Global.gameplay_settings.evFinished = true
		PuzzleAnimationPlayer.play("CompletePaperFade")
		await PuzzleAnimationPlayer.animation_finished
		PuzzleAnimationPlayer.queue("PuzzleFinished")
		await PuzzleAnimationPlayer.animation_finished
		#parent.emit_signal("evidence_complete")
