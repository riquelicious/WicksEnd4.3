class_name GlobalVariable
extends Node

# ? RNG
var rng = RandomNumberGenerator.new()

# ? Fire Instances
var fire_update_speed: float = 10.0
var fire_update_chances: int = 5
var fire_damage_cooldown_speed := 1.0
var fire_damage_value := 8

# ? Audio
# * SFX
var default_fire_linear_volume := 0.05
var default_water_linear_volume := 0.2

# ? Gestures
var gesture_list: Array = [
	"None", # 0
	"Closed_Fist", # 1
	"Open_Palm", # 2
	"Pointing_Up", # 3
	"Thumb_Down", # 4
	"Thumb_Up", # 5
	"Victory", # 6
	"ILoveYou" # 7
]
var gesture: String = gesture_list[0]

# ? Levels
var level_selection: int = 0
var level_timer_list: Array = [
	11,
	12,
	13,
	14
]

# ? points
var lvlPoints := 0

# ? Water
# var water_damage := 8.0
# var water_recovery := 6.0
# var water_extinguish_damage = 15

# ? Breakables
var breakable_damage := 5

# ? Equipments
var eqNozzleAimToggleSpeed: float = 2.0

# ? Movement
var mvTurningSensitivity: float = 0.001
var mvWalkingSpeed: float = 2.5

# ? Shop
var equipments: Dictionary = {
	"nozzle": {
		"level": 1,
		"price": {
			"cost": 100,
			"multiplier": 1.5
		},
		"capacity": {
			"increase": 6.0,
			"decrease": 8.0
		},
		"damage": 15
	},
	"axe": {
		"level": 1,
		"price": {
			"cost": 100,
			"multiplier": 1.5
		},
		"damage": 5
	},
	
	"extinguisher": {
		"level": 1,
		"price": {
			"cost": 100,
			"multiplier": 1.5
		},
		"capacity": {
			"decrease": 8.0
		},
		"damage": 15
	},

	"blanket": {
		"level": 1,
		"price": {
			"cost": 100,
			"multiplier": 1.5

		},
		"amount" : 1
	},
	
	"gear": {
		"level": 1,
		"price": {
			"cost": 100,
			"multiplier": 1.5
		},
		"defense": 5
	}
}
