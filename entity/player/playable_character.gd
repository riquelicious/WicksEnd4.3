class_name PlayerCharacter
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

enum PlayerState {
	INVENTORY,
	AIMING,
	CARRYING,
	MOVING,
	DEAD,
	INTERACTING,
	IDLE
}

# * Character Stats
var health = Stat.new(100, 0)
var water = Stat.new(100, 0)
var foam = Stat.new(100, 0)

var current_state: PlayerState = PlayerState.IDLE

# * compositions
var playerMovement: PlayerMovement = PlayerMovement.new(self)
var playerStats: StatManager = StatManager.new(self)
var uiManager: UIManager = UIManager.new(self)

func _ready():
	playerMovement._ready()
	playerStats._ready()
	uiManager._ready()

func _physics_process(delta: float) -> void:
	playerMovement._process(delta)
	playerStats._process(delta)
	uiManager._process(delta)


func is_occupied() -> bool:
	var occupied = 0
	occupied += int(current_state == PlayerState.CARRYING)
	occupied += int(current_state == PlayerState.AIMING)
	occupied += int(current_state == PlayerState.INVENTORY)
	occupied += int(current_state == PlayerState.INTERACTING)
	return bool(occupied)

class StatManager:

	var player: PlayerCharacter

	func _init(player_instance: PlayerCharacter):
		self.player = player_instance

	func _ready():
		self.player.water.regen_speed = Global.equipment_settings.calculate_stat(["nozzle", "capacity", "increase"])
		self.player.water.consume_speed = Global.equipment_settings.calculate_stat(["nozzle", "capacity", "decrease"])
		self.player.foam.regen_speed = Global.equipment_settings.calculate_stat(["extinguisher", "capacity", "increase"])
		self.player.foam.consume_speed = Global.equipment_settings.calculate_stat(["extinguisher", "capacity", "decrease"])
		self.player.health.regen_speed = 1.0

	func _process(delta):
		self.player.health.regenerate(delta)
		self.player.water.regenerate(delta)
		self.player.foam.regenerate(delta)

	func update_game_over():
		if is_player_dead():
			#TODO: game over
			pass

	func is_player_dead() -> bool:
		return self.player.health.current_amount <= 0

class PlayerMovement:

	var player: PlayerCharacter
	var gravity: Vector3
	var viewport: Viewport
	var viewport_size: Vector2
	var turning_sensitivity: float = 0.9
	var steer: float
	var walking_speed: float

	func _init(player_instance: PlayerCharacter):
		self.player = player_instance

	func _ready():
		self.gravity = self.player.get_gravity()
		self.viewport = self.player.get_viewport()
		self.viewport_size = self.viewport.get_visible_rect().size
		self.walking_speed = Global.gameplay_settings.mvWalkingSpeed

	func get_steer() -> float: # ? returns steer from mouse position
		var mouse_pos = viewport.get_mouse_position()
		var mouse_dir = (mouse_pos - viewport_size / 2).normalized() * -1 # ? get mouse position from the center of screen
		var mouse_dist = mouse_pos.distance_to(viewport_size / 2) * turning_sensitivity
		var computed_dist = clamp(mouse_dist - (viewport_size.x / 6), 0, viewport_size.x)
		return computed_dist * mouse_dir.x

	func update_player_movement(delta: float):
		if self.player.is_occupied(): return
		steer = get_steer()
		# var direction = Vector3.ZERO.normalized()
		var direction = update_walking(delta)
		update_gravity(delta)
		if direction:
			self.player.velocity.x = direction.x * walking_speed
			self.player.velocity.z = direction.z * walking_speed
		else:
			self.player.velocity.x = move_toward(player.velocity.x, 0, walking_speed)
			self.player.velocity.z = move_toward(player.velocity.z, 0, walking_speed)
		self.player.move_and_slide()

	func is_walking():
		return Global.gesture_settings.is_gesture_matching(GlobalControls.walk)

	func update_walking(delta: float) -> Vector3:
		if is_walking():
			self.player.rotate_y(deg_to_rad(steer * delta))
			if steer == 0:
				return (player.transform.basis * Vector3(0, 0, -1))
		return (player.transform.basis * Vector3.ZERO).normalized()


	func update_gravity(delta: float):
		if not self.player.is_on_floor():
			self.player.velocity.y -= self.gravity.y * delta

	func _process(delta):
		update_player_movement(delta)

class UIManager:
	var player: PlayerCharacter
	var game_ui: GameUI

	var health_ui
	var water_ui
	var foam_ui

	func _init(player_instance: PlayerCharacter):
		self.player = player_instance

	func _ready():
		self.game_ui = self.player.get_node_or_null("GameUi")
		self.health_ui = game_ui.ResourceBar.new(game_ui.health_progress_bar, self.player.health)
		self.water_ui = game_ui.ResourceBar.new(game_ui.water_progress_bar, self.player.water)
		self.foam_ui = game_ui.ResourceBar.new(game_ui.foam_progress_bar, self.player.foam)

	func _process(delta):
		self.health_ui._process(delta)
		self.water_ui._process(delta)
		self.foam_ui._process(delta)
