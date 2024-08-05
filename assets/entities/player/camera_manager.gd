class_name  CameraManager
extends Node
var player : PlayerA
var player_camera : Camera3D
var viewmodel_camera : Camera3D
var anim : AnimationPlayer
var aim_timer : Timer
var default_camera_rotation : Vector3
var equipment_manager : Node3D
var back_button_container : Control
var back_button : Control

var target_rotation_x = 0.0
var target_rotation_y = 0.0
var current_rotation_x = 0.0
var current_rotation_y = 0.0
var reset_camera := false
var previous_aim_active_status := false
var previous_gesture : String 
#var previous_gesture : String 

var shake_strength : float = 0.0
var random_strength : float = 0.05
var shake_fade : float = 1.0
var rng = RandomNumberGenerator.new()

@onready var viewport_size := get_viewport().get_visible_rect().size

func initialize(player_instance: PlayerA):
	player = player_instance
	previous_gesture = Global.gesture_settings.gesture_list[0]
	player_camera = player.get_node("player-camera")
	viewmodel_camera = player.get_node("Control/equipment-overlay/SubViewportContainer/SubViewport/viewmodel-camera")
	anim = player.get_node("AnimationPlayer")
	aim_timer = player.get_node("timers/nozzle_aim_delay")
	back_button_container = player.get_node("Control/on-screen-ui/ui/button_container")

	back_button = player.get_node("Control/on-screen-ui/ui/button_container/Back")
	default_camera_rotation = player_camera.rotation

	back_button.button_clicked.connect(reset_camera_position)
	back_button_container.visible = false


func update_aim(delta):
	if player.interaction_manager.is_civilian_carried: return
	if not player.is_aim_active and not player.is_interacting:
		if player_camera.rotation != default_camera_rotation:
			player_camera.rotation = lerp(player_camera.rotation, default_camera_rotation, 10 * delta)
	if Global.gesture_settings.gesture != previous_gesture:
		aim_timer.stop()
	if (Global.gesture_settings.gesture == GlobalControls.eqNozzleAim) and (aim_timer.time_left == 0):
		player.is_aim_active = !player.is_aim_active
		aim_timer.start(Global.gameplay_settings.eqNozzleAimToggleSpeed)
		previous_gesture = Global.gesture_settings.gesture
	if not previous_aim_active_status == player.is_aim_active:
		previous_aim_active_status = player.is_aim_active
		if player.is_aim_active:
			anim.play("aim")
			await anim.animation_finished
			player.pressurized_water.toggle_water = true
		else:
			player.pressurized_water.toggle_water = false
			anim.play_backwards("aim")
func update_nozzle_aim(delta):
	if not player.is_aim_active: return
	current_rotation_x = lerp(current_rotation_x, target_rotation_x, 10 * delta)
	current_rotation_y = lerp(current_rotation_y, target_rotation_y, 10 * delta)
	player_camera.rotation_degrees.x = current_rotation_x
	player_camera.rotation_degrees.y = current_rotation_y
func reset_camera_position():
	reset_camera = true
	back_button_container.visible = false	

func camera_shake(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shake_fade * delta)
		var offset = random_offset()
		player_camera.h_offset = offset.x
		player_camera.v_offset = offset.y

func random_offset():
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))

func apply_shake():
	shake_strength = random_strength
