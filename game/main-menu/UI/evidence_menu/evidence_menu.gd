class_name EvidenceMenu extends Control

signal evidence_complete

var pieces: Array
var piece_container: Control
var evidenceContainer: EvidenceContainer = EvidenceContainer.new(self)
var evidenceNotesManager: EvidenceNotesManager = EvidenceNotesManager.new(self)
var current_piece: int

var backButton: HoverButton
var backNode: Control

var menuSequence: MenuSequence

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
	backNode = get_node_or_null("Button")
	assert(backNode != null)
	backButton = HoverButton.new(backNode, backFunc)
	backButton._ready()
	backButton.disabled = false
	if get_parent() is MenuSequence:
		menuSequence = get_parent()

func _process(delta: float) -> void:
	pieces[0]._process(delta)
	pieces[1]._process(delta)
	pieces[2]._process(delta)
	pieces[3]._process(delta)
	evidenceContainer._process(delta)
	evidenceNotesManager._process(delta)
	backButton._process(delta)

func backFunc():
	if not Global.gameplay_settings.evFinished:
		if menuSequence is MenuSequence:
			menuSequence.set_menu(MenuSequence.Menu.LEVEL_SELECT)
	else:
		backButton.disabled = true
		emit_signal("evidence_complete")
