class_name EvidenceNotesManager extends Node

var parent: Node
var animation_player: AnimationPlayer
var note_title: Label
var note_contents: RichTextLabel
var previous_piece_index: int = -1

func _init(parent_instance: Node) -> void:
	self.parent = parent_instance

func _ready():
	self.animation_player = parent.get_node("Puzzle/PuzzleAnimation")
	self.note_title = parent.get_node("Notes/Panel/MarginContainer/VBoxContainer/Title")
	self.note_contents = parent.get_node("Notes/Panel/MarginContainer/VBoxContainer/Contents")

func switch_note(index: int):
	if SaveManager.current_save["evidence_finished"]:
		animation_player.play("PuzzleFinished")
		return
	if previous_piece_index != -1:
		animation_player.play_backwards("NotesFade")
		await animation_player.animation_finished
	note_title.text = convert_title(index)
	note_contents.text = get_notes(index)
	animation_player.play("NotesFade")

func check_pieces():
	if SaveManager.current_save["evidence_finished"]: return
	if parent.current_piece == -1: return
	if parent.current_piece != previous_piece_index:
		switch_note(parent.current_piece)
		previous_piece_index = parent.current_piece

func get_notes(index: int) -> String:
	match index:
		0:
			return note_1()
		1:
			return note_2()
		2:
			return note_3()
		3:
			return note_4()
		_:
			return ("")

func note_1() -> String:
	return (
'[center]"The apartment fire is under control.
Next, I’ll tackle the warehouse. It’s a maze
with all the cargo, so turning off the sprinklers
might be tricky, but I’ll manage it to get the
job done right."[/center]')

func note_2() -> String:
	#return ("")
	return (
'[center]"Following that, I’ll handle the house you
showed me. With its electrical appliances,
just using water won’t suffice. I’ll make sure
the fire is thorough and leaves no chance
for recovery, even if it’s more complicated."[/center]')

func note_3() -> String:
	return (
'[center]"The industrial factory will be the
final target.The presence of chemicals and weak
structures might cause a collapse, so I’ll
create a makeshift stair from the materials
inside to reach the second floor and turn off
the sprinklers. This will help the fire spread
as needed, despite the challenges."[/center]')

func note_4() -> String:
	return (
'[center]The content seems unreadable
because it’s obscured by the tear.
Perhaps if we could pieceit all together,
it might somehow become legible.
[/center]')

func _process(delta):
	check_pieces()

func convert_title(index: int) -> String:
	match index:
		0:
			return "Piece One"
		1:
			return "Piece Two"
		2:
			return "Piece Three"
		3:
			return "Piece Four"
		_:
			return ("")
