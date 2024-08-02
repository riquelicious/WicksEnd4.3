class_name Player
extends CharacterBody3D

@onready var player_camera : Camera3D = $"player-camera"
@onready var viewmodel_camera : Camera3D = $"equipment-overlay/SubViewportContainer/SubViewport/viewmodel-camera"
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var aim_timer : Timer = $"nozzle-aim-timer"
@onready var turning_pads := $"on-screen-ui/turning-pads"
@onready var turning_panel_animation := $"on-screen-ui/turning-pads/turning_panel_animation"
@onready var objective_markers := $"equipment-overlay/ObjectMarkers"
@onready var straight_interaction_raycast := $raycasts/InteractRay
@onready var back_button_container := $"on-screen-ui/ui/button_container"
@onready var back_button = $"on-screen-ui/ui/button_container/Back"
@onready var default_cam_marker = $cam_marker
@onready var viewport_size := get_viewport().get_visible_rect().size
@onready var water_particle := $"equipment-overlay/SubViewportContainer/SubViewport/viewmodel-camera/water_particles"
@onready var pressured_water := $raycasts/nozzle_water
@onready var damage_animation_player := $"on-screen-ui/overlays/AnimationPlayer"
@onready var foot_audio = $sounds/foot

@export var equipment_manager : Node3D
@export var equipment_sway_amout : float = 0.0005
#@export var speed : float = 5.0
@export var jump_velocity : float = 4.5


var default_equipment_hold_position : Vector3
var mouse_input : Vector2

# * scoping animation
var is_aim_active : bool = false
var previous_aim_active_status := false
var previous_gesture : String = GlobalVariables.gesture_list[0]
# * aiming nozzle
var sensitivity : float = 0.075
var default_camera_rotation : Vector3
var target_rotation_x = 0.0
var target_rotation_y = 0.0
var current_rotation_x = 0.0
var current_rotation_y = 0.0
# * movement
var mvHorizontalRotation : float
var mvPreviousCursorPanelPosition : int
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var stepped := false
var previous_bob_position
# * camera_management
var reset_camera := false
var default_cam_rot : Vector3
var default_cam_pos : Vector3
var is_interacting := false
var mouse_callibrated := false
# * status
var health = 100
var water = 100

func _ready():
	default_equipment_hold_position = equipment_manager.position
	default_camera_rotation = player_camera.rotation
	back_button_container.visible = false
	back_button.button_clicked.connect(_reset_camera_position)
	
func _input(event):
	if !equipment_manager: return
	if event is InputEventMouseMotion:
		target_rotation_y = -1 * (event.position.x - (viewport_size.x / 2)) * sensitivity
		target_rotation_x = -1 * (event.position.y - (viewport_size.y / 2)) * sensitivity

func _toggle_aim(delta):
	# ? reset rotation to default after aim
	if not is_aim_active and not is_interacting:
		if player_camera.rotation != default_camera_rotation:
			player_camera.rotation = lerp(player_camera.rotation,\
			default_camera_rotation,\
			10 * delta)
	# ? Checks if there's changes on gesture
	if GlobalVariables.gesture != previous_gesture: 
		aim_timer.stop()
	# ? Toggles aim if timer is 0 then sets a cooldown for aiming
	if (GlobalVariables.gesture == GlobalControls.eqNozzleAim) and (aim_timer.time_left == 0):
		is_aim_active = !is_aim_active
		aim_timer.start(GlobalVariables.eqNozzleAimToggleSpeed)
		previous_gesture = GlobalVariables.gesture
	# ? plays animation depending on active status	
	if not previous_aim_active_status == is_aim_active: 
		previous_aim_active_status = is_aim_active
		if is_aim_active:
			anim.play("aim")
			await anim.animation_finished
			pressured_water.toggle_water = true
		else:
			pressured_water.toggle_water = false
			anim.play_backwards("aim")

func _do_nozzle_aim(delta):
	if !is_aim_active: return
	current_rotation_x = lerp(current_rotation_x, target_rotation_x, 10 * delta)
	current_rotation_y = lerp(current_rotation_y, target_rotation_y, 10 * delta)
	player_camera.rotation_degrees.x = current_rotation_x
	player_camera.rotation_degrees.y = current_rotation_y

func equipment_sway(delta):
	mouse_input = lerp(mouse_input, Vector2.ZERO, 10 * delta)
	equipment_manager.rotation.x = lerp(equipment_manager.rotation.x,\
	mouse_input.y * equipment_sway_amout,\
	10 * delta)
	equipment_manager.rotation.y = lerp(equipment_manager.rotation.y,\
	mouse_input.x * equipment_sway_amout,\
	10 * delta)

func equipment_bob(vel : float, delta):
	if equipment_manager:
		if vel > 0:
			var bob_amount : float = 0.01
			var bob_freq : float = 0.01
			equipment_manager.position.z = lerp(equipment_manager.position.z,\
			default_equipment_hold_position.z + sin(Time.get_ticks_msec() * bob_freq)\
			* bob_amount, 10 * delta)
			equipment_manager.position.y = lerp(equipment_manager.position.y,\
			default_equipment_hold_position.y + sin(Time.get_ticks_msec() * bob_freq)\
			* bob_amount, 10 * delta)
			_calculate_foot_dir(equipment_manager.position.y)
		else:
			equipment_manager.position.z = lerp(equipment_manager.position.z,\
			default_equipment_hold_position.z,\
			10 * delta)
			equipment_manager.position.y = lerp(equipment_manager.position.y,\
			default_equipment_hold_position.y,\
			10 * delta)
			
			
func _movement(delta):
	if is_aim_active: return
	var direction = Vector3.ZERO.normalized()
	if GlobalVariables.gesture == GlobalControls.mvWalk:
		rotate_y(deg_to_rad( + mvHorizontalRotation * delta))
		_turningpad_fade()
		if mvHorizontalRotation != 0:
			direction = (transform.basis * Vector3.ZERO).normalized()
		else:
			direction = (transform.basis * Vector3(0,0, -1)).normalized()
			pass
	if not is_on_floor():
		velocity.y -= gravity * delta
	if direction:
		velocity.x = direction.x * GlobalVariables.mvWalkingSpeed
		velocity.z = direction.z * GlobalVariables.mvWalkingSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, GlobalVariables.mvWalkingSpeed)
		velocity.z = move_toward(velocity.z, 0, GlobalVariables.mvWalkingSpeed)
	move_and_slide()

func _turningpad_fade():
	if turning_pads.cursor_position == mvPreviousCursorPanelPosition: return
	if mvPreviousCursorPanelPosition == turning_pads.MODE_CUR_LEFT:
			turning_panel_animation.play_backwards("fade_left_panel")
	elif mvPreviousCursorPanelPosition == turning_pads.MODE_CUR_RIGHT:
		turning_panel_animation.play_backwards("fade_right_panel")
	match turning_pads.cursor_position:
		turning_pads.MODE_CUR_LEFT:
			turning_panel_animation.play("fade_left_panel")
		turning_pads.MODE_CUR_RIGHT:
			turning_panel_animation.play("fade_right_panel")
	mvPreviousCursorPanelPosition = turning_pads.cursor_position

func _check_collision(_delta):
	var collider = straight_interaction_raycast.get_collider()
	if collider:
		if collider.is_in_group("breakable"):
			objective_markers.switch_crosshair("breakable")
			if GlobalVariables.gesture == GlobalControls.eqAxeSwing:
				_change_equipment(1)
				collider.do_damage(GlobalVariables.breakable_damage)
		elif collider.is_in_group("interactable"):
			objective_markers.switch_crosshair("interaction")
			if GlobalVariables.gesture == GlobalControls.mvInteract:
				collider.default_camera_position = default_cam_marker.global_position
				collider.is_interacting = true
				is_interacting = true
				#* rest of the code
				collider.do_camera_positioned = true
				back_button_container.visible = true 
			elif reset_camera:
				is_interacting = false
				reset_camera = false
				collider.do_camera_positioned = false
				back_button_container.visible = false
	else:
		objective_markers.switch_crosshair("crosshair")
		_change_equipment(0)

func _reset_camera_position():
	reset_camera = true
	back_button_container.visible = false
	
func _change_equipment(equipment: int):
	var equipments = equipment_manager.get_children()
	if equipments[equipment].visible == true:
		return
	else:
		for eq in equipments:
			eq.visible = false
		equipments[equipment].visible = true

func _physics_process(delta):
	_check_collision(delta)
	if is_interacting: return
	_movement(delta)
	_toggle_aim(delta)
	_do_nozzle_aim(delta)
	equipment_sway(delta)
	equipment_bob(velocity.length(), delta)
	
func _footstep_play_sound():
	var rand_index := randi() % len(FilePaths.foot_step_sounds)
	foot_audio.stream = AudioStreamOggVorbis.load_from_file(FilePaths.foot_step_sounds[rand_index - 1])
	foot_audio.stream_paused = false
	foot_audio.play()

func _calculate_foot_dir(current_position):
	if previous_bob_position == null:
		previous_bob_position = current_position
	if current_position > previous_bob_position:
		stepped = false
	else:
		if not stepped:
			stepped = true
			_footstep_play_sound()
	previous_bob_position = current_position
