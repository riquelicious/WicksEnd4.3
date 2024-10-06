extends Node
class_name GameplaySettings


var eqAimToggleSpeed: float = 2.0
var uiInvToggleSpeed: float = 2.0

var mvTurningSensitivity: float = 0.001
var mvWalkingSpeed: float = 4.0

var evFinished: bool = false
# var evPiece: Dictionary = {
# 	"0": false,
# 	"1": false,
# 	"2": false,
# 	"3": false
# }
var evPiece: Dictionary = {
	"0": true,
	"1": true,
	"2": true,
	"3": true
}

var from_level := false