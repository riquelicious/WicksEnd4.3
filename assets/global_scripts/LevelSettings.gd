extends Node
class_name LevelSettings
# Level
var level_timer_list: Array = [
	600,
	900,
	600,
	1200
]

var unlocked_levels = {
	"0": true,
	"1": false,
	"2": false,
	"3": false
}

var level_selection: int = 0
var lvlPoints := 0.0
var curPoints := 0.0
var civilians_remaining := 0

var quest_message = ""

var extinguished_percentage = 0.0
