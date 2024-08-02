extends Node

var save_path = "user://wicks_end.json"

var blank_save = {
	"evidence": {
		"0": false,
		"1": false,
		"2": false,
		"3": false
	},
	"evidence_finished": false,
	"help": {
		"0": false,
		"1": false,
		"2": false,
		"3": false,
		"4": false,
		"5": false
	},
	"levels": {
		"0": 0,
		"1": 1,
		"2": 2,
		"3": 3,
		"4": 4,
		"5": false
	},
	"points": 1000,
	"upgrade": {
		"axe": 0,
		"blanket": 0,
		"extinguisher": 0,
		"gear": 0,
		"nozzle": 0
	}
}


var current_save : Dictionary

func _ready() -> void:
	current_save = blank_save.duplicate(true)

func save_data():
	fetch_data(current_save)
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	if file:
		var json_data = JSON.stringify(current_save, "\t")
		file.store_line(json_data)
		file.close()

func load_data():
	if not FileAccess.file_exists(save_path):
		return 
	var content = FileAccess.get_file_as_string(save_path)
	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		var result = json.data
		current_save = result
		update_data(current_save)
	else:
		push_warning("Savefile Corrupted")

func new_data():
	current_save = blank_save.duplicate(true)
	update_data(current_save)

func update_data(save : Dictionary) -> void:
	var equipments = Global.equipment_settings.equipments
	var levels = Global.level_settings.unlocked_levels
	var _points = Global.level_settings.lvlPoints
	for eq in equipments.keys():
		equipments[eq]["level"] = save["upgrade"][eq]
	for level in len(levels):
		levels[level] = save["levels"][str(level + 1)]
	_points = save["points"]

func fetch_data(save : Dictionary):
	var equipments = Global.equipment_settings.equipments
	var levels = Global.level_settings.unlocked_levels
	var points = Global.level_settings.lvlPoints
	for eq in equipments.keys():
		save["upgrade"][eq] = equipments[eq]["level"]
	for level in len(levels):
		save["levels"][level] = level
	save["points"] = points 
