class_name PlayerAbstract
extends CharacterBody3D

enum state {
	INVENTORY,
	AIMING,
	CARRYING,
	MOVING,
	DEAD,
	INTERACTING,
	IDLE
}

var current_state = state.IDLE

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var interaction_manager: InteractionManager = InteractionManager.new(self)
var movement_manager: MovementManager = MovementManager.new(self)
var audio_manager: AudioManager = AudioManager.new(self)
var camera_manager: CameraManager = CameraManager.new(self)

var health_bar = Stat.new(100, 0)
var nozzle_bar = Stat.new(100, 0)
var extinguisher_bar = Stat.new(100, 0)

func _ready():
	interaction_manager._ready()
	movement_manager._ready()
	audio_manager._ready()
	camera_manager._ready()
	update_bars()


func update_bars():
	nozzle_bar.regen_speed = Global.equipment_settings.calculate_stat(["nozzle", "capacity", "increase"])
	nozzle_bar.consume_speed = Global.equipment_settings.calculate_stat(["nozzle", "capacity", "decrease"])
	extinguisher_bar.regen_speed = Global.equipment_settings.calculate_stat(["extinguisher", "capacity", "increase"])
	extinguisher_bar.consume_speed = Global.equipment_settings.calculate_stat(["extinguisher", "capacity", "decrease"])
	health_bar.regen_speed = 1.0

func check_health():
	if not health_bar: return
	if health_bar.current_amount <= 0:
		if current_state != state.DEAD:
			game_over()
			current_state = state.DEAD

func game_over():
	var go = $%game_over
	if go:
		go.game_over()


func is_occupied() -> bool:
	if current_state == state.CARRYING or current_state == state.AIMING or current_state == state.INVENTORY or current_state == state.INTERACTING:
		return true
	return false

func _process(delta: float) -> void:
	health_bar.regenerate(delta)
	nozzle_bar.regenerate(delta)
	extinguisher_bar.regenerate(delta)
