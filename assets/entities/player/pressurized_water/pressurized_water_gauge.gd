class_name PressurizedWaterGauge
extends Node3D

var pressurized_water
var active := false
var timer := 0.0
const update_delay := 2.0
var water_depletion : float
var water_replenish : float

func initialize(pressurized_water_instance: PressurizedWater):
	pressurized_water = pressurized_water_instance
	water_depletion = Global.equipment_settings.calculate_stat(["nozzle","capacity","decrease"])
	water_replenish = Global.equipment_settings.calculate_stat(["nozzle","capacity","increase"])


func update_water_gauge(delta):
	update_water_status(delta)
	if active:
		pressurized_water.player.water = clamp(pressurized_water.player.water - (water_depletion * delta), 0, 100)
	else:
		pressurized_water.player.water =  clamp(pressurized_water.player.water + (water_replenish * delta), 0, 100)

func update_water_status(delta):
	if not pressurized_water.player.is_aim_active: return
	if pressurized_water.player.water <= 0.0:
		pressurized_water.toggle_water = false
	else:
		timer += delta
		if timer < update_delay: return
		timer = 0.0
		pressurized_water.toggle_water = true
