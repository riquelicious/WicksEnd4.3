extends interactables

@export var rotation_amount := 3
var valve_manager : ValveManager = ValveManager.new()

func _ready() -> void:
	super()
	valve_manager.initialize(self)
	
func _process(delta: float) -> void:
	super(delta)
	valve_manager.update_rotation(delta)
