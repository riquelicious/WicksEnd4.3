extends Node
class_name EquipmentSettings


var equipments: Dictionary = {
	"nozzle": {
		"level": 1.0,
		"price": {
			"base": 180.0,
			"multiplier": 0.5
		},
		"capacity": {
			"increase": {
				"base": 6.0,
				"multiplier" : 0.1
			},
			"decrease": {
				"base" : 8.0,
				"multiplier" : -0.05
			},
		},
		"damage": {
			"base" : 5.0,
			"multiplier" : 0.5
		}
	},
	"axe": {
		"level": 1.0,
		"price": {
			"base": 200.0,
			"multiplier": 0.5
		},
		"damage": {
			"base" : 20.0,
			"multiplier" : 0.5
		},
		"swing" : {
			"base" : 100.0,
			"multiplier" : 0.1
		}
	},
	
	"extinguisher": {
		"level": 1.0,
		"price": {
			"base": 250.0,
			"multiplier": 0.5
		},
		"capacity": {
			"decrease": {
				"base" : 8.0,
				"multiplier" : -0.05
			}
		},
		"damage": {
			"base" : 10.0,
			"multiplier" : 0.25
		}
	},

	"blanket": {
		"level": 1.0,
		"price": {
			"base": 100.0,
			"multiplier": 0.5

		},
		"amount" : {
			"base" : 1.0,
			"multiplier" : 1.0
		}
	},
	
	"gear": {
		"level": 1.0,
		"price": {
			"base": 500.0,
			"multiplier": 0.5
		},
		"defense": {
			"base" : 5.0,
			"multiplier" : 1.0
		}
	}
}

func calculate_stat(keys : Array) -> float:
	var eq = equipments
	var level = eq[keys[0]]["level"]
	for key in keys:
		eq = eq[key]
	var base = eq["base"]
	var multiplier = eq["multiplier"]
	var value = base + ((base * multiplier) * level - 1)
	return value
