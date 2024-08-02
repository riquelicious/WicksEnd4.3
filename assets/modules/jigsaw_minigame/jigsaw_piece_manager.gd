class_name JigsawPieceManager
extends Node

var dragging = false
var finished = false
var offset = null
var parent : TextureRect
var main : Control

func initialize(main_instance : Control ,parent_instance : TextureRect):
	main = main_instance
	parent = parent_instance

func detect_drag():
	if not main.current_piece or main.current_piece == parent.name:
		var mouse_pos = GlobalCursor.cursor_sprite.position
		if Global.gesture_settings.gesture == GlobalControls.mgJigsaw:
			if parent.get_global_rect().has_point(mouse_pos):
				dragging = true
				if not offset:
					offset = mouse_pos - parent.global_position
					main.current_piece = parent.name
					main.jigsaw_manager.piece_container.move_child(parent, 3)
				parent.global_position = mouse_pos - offset
			return
		offset = null
		main.current_piece = null
