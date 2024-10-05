extends Node2D
@onready var health_mask = $health/health_mask
@onready var water_mask = $water/water_mask

@export var player: PlayerEntity

var health_sprite_width
var water_sprite_width
var health_increment_value
var water_increment_value
var previous_health_val_flag = 100
var current_eq := 0

func _ready():
	health_sprite_width = health_mask.texture.get_width()
	water_sprite_width = water_mask.texture.get_width()
	health_increment_value = health_sprite_width / 100.0
	water_increment_value = water_sprite_width / 100.0

func _process(delta):
	return #TODO
	if player:
		health_mask.position.x = lerp(health_mask.position.x, 0.0 - health_increment_value * float(100 - player.health), delta * 10)
		if current_eq == 0:
			water_mask.position.x = lerp(water_mask.position.x, 0.0 - water_increment_value * float(100 - player.water), delta * 10)
		elif current_eq == 2:
			water_mask.position.x = lerp(water_mask.position.x, 0.0 - water_increment_value * float(100 - player.extinguisher), delta * 10)
	else:
		push_error("Add player! : Gauge")
