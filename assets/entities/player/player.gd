class_name PlayerA
extends CharacterBody3D

@export var camera_sensitivity : float = 0.075

@onready var default_cam_marker = $cam_marker
@onready var damage_animation_player := $"Control/on-screen-ui/overlays/AnimationPlayer"
@onready var objective_markers := $"Control/equipment-overlay/ObjectMarkers"
@onready var back_button = $"Control/on-screen-ui/ui/button_container/Back"
@onready var gauges := $Control/gauges
@onready var viewport_size := get_viewport().get_visible_rect().size
@onready var viewport := get_viewport()
@onready var camera_manager : CameraManager = CameraManager.new()
@onready var equipment_manager : EquipmentManger = EquipmentManger.new()
@onready var movement_manager : MovementManager = MovementManager.new()
@onready var interaction_manager : InteractionManager = InteractionManager.new()
@onready var audio_manager : AudioManager = AudioManager.new()
@onready var pressurized_water : PressurizedWater = PressurizedWater.new()
@onready var point_manager : PointManager = PointManager.new()

var is_aim_active : bool = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_interacting := false
var health = 100
var water = 100.0

func _ready():
	camera_manager.initialize(self)
	equipment_manager.initialize(self)
	movement_manager.initialize(self)
	interaction_manager.initialize(self)
	audio_manager.initialize(self)
	pressurized_water.initialize(self)
	point_manager.initialize(self)
	camera_manager.back_button_container.visible = false
	back_button.button_clicked.connect(camera_manager.reset_camera_position)

func _input(event):
	if event is InputEventMouseMotion:
		camera_manager.target_rotation_y = -1 * (event.position.x - (viewport_size.x / 2)) * camera_sensitivity
		camera_manager.target_rotation_x = -1 * (event.position.y - (viewport_size.y / 2)) * camera_sensitivity

func _physics_process(delta):
	interaction_manager.check_collision()
	point_manager.update_points(delta)
	pressurized_water.update_water_stream(delta)
	if is_interacting: return
	movement_manager.update_movement(delta)
	camera_manager.update_aim(delta)
	camera_manager.update_nozzle_aim(delta)
	equipment_manager.update_sway(delta)
	equipment_manager.update_bob(velocity.length(),delta)
