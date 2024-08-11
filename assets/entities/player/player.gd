class_name PlayerA
extends CharacterBody3D

@export var camera_sensitivity : float = 0.1
@onready var default_cam_marker = $cam_marker
@onready var damage_animation_player := $"Control/on-screen-ui/overlays/AnimationPlayer"
@onready var viewport_size := get_viewport().get_visible_rect().size
@onready var viewport := get_viewport()
@onready var object_markers: Control = $"Control/equipment-overlay/ObjectMarkers"

var camera_manager : CameraManager = CameraManager.new() 
var equipment_manager : EquipmentManger = EquipmentManger.new()
var movement_manager : MovementManager = MovementManager.new()
var interaction_manager : InteractionManager = InteractionManager.new()
var audio_manager : AudioManager = AudioManager.new()
var pressurized_water : PressurizedWater = PressurizedWater.new()
var extinguisher_manager : ExtinguisherManager = ExtinguisherManager.new() 
var point_manager : PointManager = PointManager.new()
var inventory_manager : InventoryManager = InventoryManager.new()

var is_aim_active : bool = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_interacting := false
var health = 100.0
var water = 100.0
var extinguisher = 100.0
var dead := false

func _ready():
	camera_manager.initialize(self)
	equipment_manager.initialize(self)
	movement_manager.initialize(self)
	interaction_manager.initialize(self)
	audio_manager.initialize(self)
	pressurized_water.initialize(self)
	point_manager.initialize(self)
	extinguisher_manager.initialize(self)
	inventory_manager.initialize(self)
	BGM.change_bgm("res://assets/audio/BGM/HurryTFup.mp3")


func _input(event):
	if event is InputEventMouseMotion:
		camera_manager.target_rotation_y = -1 * (event.position.x - (viewport_size.x / 2)) * camera_sensitivity
		camera_manager.target_rotation_x = -1 * (event.position.y - (viewport_size.y / 2)) * camera_sensitivity

func _physics_process(delta):
	check_health()
	interaction_manager.check_collision()
	point_manager.update_points(delta)
	pressurized_water.update_water_stream(delta)
	extinguisher_manager.update_extinguisher(delta)
	camera_manager.camera_shake(delta)
	if is_interacting: return
	inventory_manager.toggle_inventory(delta)
	equipment_manager.update_sway(delta)
	equipment_manager.update_bob(velocity.length(),delta)
	if inventory_manager.is_inventory: 
		inventory_manager.select_equipment()
		return
	camera_manager.update_aim(delta)
	camera_manager.update_nozzle_aim(delta)
	movement_manager.update_movement(delta)

func check_health():
	if health <=0:
		if not dead:
			game_over()
			dead = true
			
func game_over():
	var game_over = $%game_over
	if game_over:
		game_over.game_over()
