class_name EvidenceMenu extends Control

var pieces: Array
var piece_container: Control
var evidenceContainer: EvidenceContainer = EvidenceContainer.new(self)
var evidenceNotesManager: EvidenceNotesManager = EvidenceNotesManager.new(self)
var current_piece: int

var positions: Array = [
	Vector2(20, 20),
	Vector2(20, 108),
	Vector2(20, 216),
	Vector2(20, 288)
]

func _ready() -> void:
	piece_container = get_node("Puzzle/PieceContainer")
	for piece in piece_container.get_children():
		pieces.append(EvidencePiece.new(self, piece, pieces.size()))
	evidenceContainer._ready()
	evidenceNotesManager._ready()

func _process(delta: float) -> void:
	pieces[0]._process(delta)
	pieces[1]._process(delta)
	pieces[2]._process(delta)
	pieces[3]._process(delta)
	evidenceContainer._process(delta)
	evidenceNotesManager._process(delta)
