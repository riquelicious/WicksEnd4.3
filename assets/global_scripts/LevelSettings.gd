extends Node
class_name LevelSettings
# Level
var level_timer_list: Array = [
	11,
	12,
	13,
	14
]

var unlocked_levels = {
	"0" : true,
	"1" : false,
	"2" : false,
	"3" : false
}

var level_selection: int = 0
var lvlPoints := 1000.0

