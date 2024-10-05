class_name ExtinguisherLiquid extends LiquidAbstract

var liquid_timer_increment: float = 0.0
var liquid_timer_cap: float = 0.3


func _ready():
	super._ready()
	liquid_particle = player.get_node_or_null("particles/ExtinguisherLiquidParticle")
	liquidbar = player.extinguisher_bar
	raycast = camera.get_node("extinguisher_ray")
	damage = Global.equipment_settings.calculate_stat(["extinguisher", "damage"])
	self.liquid_particle.emitting = false

func update_status(delta: float) -> void:
	if not player.inventory_manager.current_equipment == player.inventory_manager.equipments.FIRE_EXTINGUISHER: return
	super.update_status(delta)

func while_emitting(delta: float) -> void:
	liquid_timer_increment += delta
	if liquid_timer_increment < liquid_timer_cap: return
	liquid_timer_increment = 0.0
	emmit_liquid()
	#liquidbar.set_consume_loop(true)
	liquidbar.consume_loop(delta)


func while_not_emitting(delta: float) -> void:
	liquid_timer_increment = 0.0
	#liquidbar.set_consume_loop(false)

func emmit_liquid() -> void:
	detect_collision()
