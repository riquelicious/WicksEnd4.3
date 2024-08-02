class_name SceneJsonManager
extends Node

var parent : Node

func initialize(parent_instance : Node):
	parent = parent_instance

func load_json(file_index: int):
	var file = FilePaths.script_file_list[file_index]
	var content = FileAccess.get_file_as_string(file)
	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		var result = json.data
		return result["nodes"]
	else:
		push_warning("JSON Parsing Error")
	