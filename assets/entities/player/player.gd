class_name PlayerEntity
extends PlayerAbstract

@onready var damage_animation_player := $"Control/on-screen-ui/overlays/AnimationPlayer"

var equipment_manager: EquipmentManger = EquipmentManger.new(self)
#var pressurized_water: PressurizedWater = PressurizedWater.new(self)
#var extinguisher_manager: ExtinguisherManager = ExtinguisherManager.new()
var point_manager: PointManager = PointManager.new()
var inventory_manager: InventoryManager = InventoryManager.new(self)
var nozzleLiquid: NozzleLiquid = NozzleLiquid.new(self)
var extinguisherLiquid: ExtinguisherLiquid = ExtinguisherLiquid.new(self)

# # #TODO: Change 
# var health = 100.0
# var water = 100.0
# var extinguisher = 100.0

func _ready():
	super._ready()
	equipment_manager._ready()
	#pressurized_water._ready()
	point_manager.initialize(self)
	#extinguisher_manager.initialize(self)
	inventory_manager._ready()
	nozzleLiquid._ready()
	extinguisherLiquid._ready()

func _input(event):
	camera_manager._input(event)

func _physics_process(delta):
	check_health()
	interaction_manager.check_collision()
	point_manager.update_points(delta)
	#pressurized_water.update_water_stream(delta)
	#extinguisher_manager.update_extinguisher(delta)
	camera_manager._physics_process(delta)
	movement_manager.update_movement(delta)
	nozzleLiquid._physics_process(delta)
	extinguisherLiquid._physics_process(delta)

func _process(delta):
	super._process(delta)
	equipment_manager._process(delta)
	inventory_manager._process(delta)
