extends Node
class_name LevelSettings
# Level
var level_timer_list: Array = [
	encode_time(15, 0),
	encode_time(15, 0),
	encode_time(10, 0),
	encode_time(20, 0)
]

func encode_time(m: float, s: float):
	print("encoded time: " + str(m) + " " + str(s) + " = " + str(decode_time(m + s / 60.0)))
	return m + s / 60.0

func decode_time(encoded_time: float):
	return encoded_time * 60

func get_level_time():
	return decode_time(level_timer_list[level_selection])

var unlocked_levels = {
	"0": true,
	"1": false,
	"2": false,
	"3": false
}

func unlock_next_level():
	if level_selection < unlocked_levels.size() - 1:
		unlocked_levels[str(level_selection + 1)] = true


var level_selection: int = 0
var lvlPoints := 0.0
var curPoints := 0.0
var civilians_remaining := 0

var quest_message = ""

var extinguished_percentage = 0.0
