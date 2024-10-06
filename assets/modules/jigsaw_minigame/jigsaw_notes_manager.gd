class_name JigsawNotesManager
extends Node

var parent: Node
var notes: Array
var animation_player: AnimationPlayer
var prev_piece_index: int = -1
var pieces = [
	"piece #1",
	"piece #2",
	"piece #3",
	"piece #4"
]

func initialize(parent_instance: Node):
	parent = parent_instance
	notes = parent.get_node("notes/CenterContainer/container").get_children()
	animation_player = parent.get_node("AnimationPlayer")
	switch_note(-1)

func switch_note(index: int):
	if SaveManager.current_save["evidence_finished"]:
		animation_player.play("finished")
		return
	animation_player.play_backwards("fade_notes")
	await animation_player.animation_finished
	for note in notes:
		note.visible = false
	if index != -1:
		notes[index].visible = true

	animation_player.play("fade_notes")
	await animation_player.animation_finished

func check_piece():
	if SaveManager.current_save["evidence_finished"]: return
	var piece_id = pieces.find(parent.current_piece)
	if piece_id == -1: return
	if piece_id != prev_piece_index:
		prev_piece_index = piece_id
		switch_note(piece_id)
