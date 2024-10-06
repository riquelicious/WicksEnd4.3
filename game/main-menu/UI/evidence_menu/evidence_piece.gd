class_name EvidencePiece extends Node

var dragging = false
var finished = false
var offset = null
var parent: Control
var piece_node: TextureRect
var piece_index: int

func _init(parent_instance: Control, piece_node_instance: TextureRect, piece_index_temp: int):
	self.parent = parent_instance
	self.piece_node = piece_node_instance
	self.piece_index = piece_index_temp

func _process(delta):
	detect_drag()

func detect_drag():
	if parent.evidenceContainer.finished: return
	if is_current_piece(): # piece_node.name:
		var mouse_pos = GlobalCursor.cursor_sprite.position
		if Global.gesture_settings.is_gesture_matching(GlobalControls.jigsaw):
			if piece_node.get_global_rect().has_point(mouse_pos):
				dragging = true
				if not offset:
					offset = mouse_pos - piece_node.global_position
					parent.current_piece = piece_index # piece_node.name
					parent.evidenceContainer.piece_container.move_child(piece_node, 3)
				piece_node.global_position = mouse_pos - offset
			return
		offset = null
		parent.current_piece = -1

func is_current_piece() -> bool:
	return parent.current_piece == piece_index or parent.current_piece == -1
