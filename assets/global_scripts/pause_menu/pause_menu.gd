extends Node

@export var enabled := true

func _notification(what):
	if not enabled: return
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		push_warning("Window unfocused")
		_pause_window()
	elif what == NOTIFICATION_APPLICATION_FOCUS_IN:
		push_warning("Window focused")
		_unpause_window()

func _pause_window():
	for child in get_tree().root.get_children():
		if child.name != self.name:
			child.process_mode = Node.PROCESS_MODE_DISABLED

func _unpause_window():
	for child in get_tree().root.get_children():
		if child.name != self.name:
			child.process_mode = Node.PROCESS_MODE_INHERIT

