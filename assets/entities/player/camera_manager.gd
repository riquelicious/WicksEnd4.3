class_name CameraManager
extends Node

var player: PlayerEntity
var player_camera: Camera3D
var viewmodel_camera: Camera3D
var anim: AnimationPlayer
var aim_timer: Timer
var default_camera_rotation: Vector3
var equipment_manager: Node3D
var back_button_container: Control
var back_button_node: Control
var rng = RandomNumberGenerator.new()
var back_button: HoverButton
#@onready var GlobalGesture = Global.gesture_settings

var target_rotation_x = 0.0
var target_rotation_y = 0.0
var current_rotation_x = 0.0
var current_rotation_y = 0.0
var shake_strength: float = 0.0
var random_strength: float = 0.05
var shake_fade: float = 1.0
var reset_camera := false
var previous_aim_active_status: int

var player_occupied: bool
var previous_gesture: int
var viewport_size: Vector2
var camera_sensitivity: float = 0.1

func _init(player_instance: PlayerEntity) -> void:
	self.player = player_instance

func _ready() -> void:
	previous_gesture = GlobalControls.gestures.none
	#player_camera = player.get_node("player-camera")
	player_camera = player.get_viewport().get_camera_3d()
	viewmodel_camera = player.get_node_or_null("PlayerUI/EquipmentOverlay/SubViewport/viewmodel-camera")

	# viewmodel_camera = player.get_node_or_null("Control/equipment-overlay/SubViewportContainer/SubViewport/viewmodel-camera")
	anim = player.get_node_or_null("AnimationPlayer")
	aim_timer = player.get_node_or_null("timers/nozzle_aim_delay")
	# back_button_container = player.get_node_or_null("Control/on-screen-ui/ui/button_container")
	# back_button = player.get_node_or_null("Control/on-screen-ui/ui/button_container/Back")
	back_button_node = player.get_node_or_null("PlayerUI/ScreenUI/BotUI/LeftPanel/Button")
	default_camera_rotation = player_camera.rotation
	#back_button.button_clicked.connect(reset_camera_position)
	# back_button_container.visible = false
	assert(back_button_node)
	back_button = HoverButton.new(back_button_node, reset_camera_position)
	self.viewport_size = player.get_viewport().get_visible_rect().size


func _physics_process(delta: float) -> void:
	camera_shake(delta)
	update_aim(delta)
	update_nozzle_aim(delta)

func _input(event: InputEvent) -> void:
	if viewport_size == null: return
	if event is InputEventMouseMotion:
			target_rotation_y = -1 * (event.position.x - (viewport_size.x / 2)) * camera_sensitivity
			target_rotation_x = -1 * (event.position.y - (viewport_size.y / 2)) * camera_sensitivity

func update_aim(delta):
	if player.is_occupied() and player.current_state != player.state.AIMING: return
	var anim_type
	match player.inventory_manager.current_equipment:
		0: # nozzle
			anim_type = "nozzle_aim"
		2: # extinguisher
			anim_type = "extinguisher_aim"
		_:
			return
	reset_aim(delta)
	stop_timer()
	if anim_type:
		update_aim_status(anim_type, player.inventory_manager.current_equipment)
	if aim_timer.time_left == 0:
		if Global.gesture_settings.is_gesture_matching(GlobalControls.useEquipment):
			if player.current_state == player.state.AIMING:
				player.current_state = player.state.IDLE
			else:
				player.current_state = player.state.AIMING
		previous_gesture = Global.gesture_settings.current_gesture
		aim_timer.start(Global.gameplay_settings.eqAimToggleSpeed)

func update_aim_status(anim_type: String, equipement_index: int):
	# if not previous_aim_active_status != player.current_state: return
	# previous_aim_active_status = player.current_state


	if previous_aim_active_status != player.current_state:
		previous_aim_active_status = player.current_state
		if player.current_state == player.state.AIMING:
			anim.play(anim_type)
			await anim.animation_finished
			#player.current_state = player.state.IDLE
			# if not player.extinguisher_manager.toggle_extinguisher:
			# 	player.pressurized_water.toggle_water = equipement_index == 0
			# if not player.pressurized_water.toggle_water:
			# 	player.extinguisher_manager.toggle_extinguisher = equipement_index == 2
		else:
			#player.pressurized_water.toggle_water = false
			#player.extinguisher_manager.toggle_extinguisher = false
			#player.current_state = player.state.AIMING
			#player.current_state = player.state.IDLE
			anim.play_backwards(anim_type)


func reset_aim(delta):
	if not player.current_state == player.state.AIMING and not player.is_occupied():
		if player_camera.rotation != default_camera_rotation:
			player_camera.rotation = lerp(player_camera.rotation, default_camera_rotation, 10 * delta)

func stop_timer():
	if not Global.gesture_settings.is_gesture_matching(previous_gesture):
		aim_timer.stop()

func update_nozzle_aim(delta):
	if not player.current_state == player.state.AIMING: return
	current_rotation_x = lerp(current_rotation_x, target_rotation_x, 10 * delta)
	current_rotation_y = lerp(current_rotation_y, target_rotation_y, 10 * delta)
	player_camera.rotation_degrees.x = current_rotation_x
	player_camera.rotation_degrees.y = current_rotation_y

func reset_camera_position():
	reset_camera = true
	back_button_container.visible = false

func camera_shake(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		var offset = random_offset()
		player_camera.h_offset = offset.x
		player_camera.v_offset = offset.y

func random_offset():
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func apply_shake():
	shake_strength = random_strength
