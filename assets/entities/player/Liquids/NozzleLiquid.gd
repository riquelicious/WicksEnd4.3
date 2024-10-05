class_name NozzleLiquid extends LiquidAbstract

const force := 20.0
const gravity := Vector3.DOWN * 9.8
const segment_length := 0.5
const num_segments := 15
const line_thickness := 0.04
const line_height := 0.04

var current_segment = 0
var current_position
var direction: Vector3 = Vector3.ZERO
var line_velocity: Vector3

func _ready():
	super._ready()
	liquid_particle = player.get_node_or_null("particles/NozzleLiquidParticle")
	liquidbar = player.nozzle_bar
	raycast = player.get_node_or_null("raycasts/nozzle_ray")
	damage = Global.equipment_settings.calculate_stat(["nozzle", "damage"])
	self.liquid_particle.emitting = false

func update_status(delta: float) -> void:
	if not player.inventory_manager.current_equipment == player.inventory_manager.equipments.NOZZLE: return
	super.update_status(delta)


func while_emitting(delta: float) -> void:
	#liquidbar.set_consume_loop(true)
	liquidbar.consume_loop(delta)
	emmit_liquid()
	
func while_not_emitting(delta: float) -> void:
	#liquidbar.set_consume_loop(false)
	raycast.position = Vector3.ZERO
	raycast.target_position = Vector3.ZERO
	current_segment = 0
	current_position = player.to_local(end_point.global_position)


func emmit_liquid() -> void:
	var origin := player.to_local(end_point.global_position)
	reset_segment()
	line_velocity = direction * force
	update_particle_position()
	if current_segment < num_segments:
		var time = current_segment * segment_length / line_velocity.length()
		var next_position = origin + line_velocity * time + 0.5 * gravity * time * time # Vector3(0, gravity, 0)
		raycast.position = current_position
		raycast.target_position = next_position - current_position
		#var valid_collider = detect_collision()
		if detect_collision():
			steam_particle.position = next_position
			current_position = origin
			current_segment = 0
		else:
			current_segment += 1
			current_position = next_position
		return
	current_segment = 0
	current_position = origin

func reset_segment():
	var face_front = -camera.transform.basis.z.normalized()
	if (direction - -camera.transform.basis.z.normalized()).length() > 0.8:
		current_segment = 0
	if current_segment == 0 or direction == null:
		direction = face_front

func extinguish_fire(col: FireInstance) -> void:
	col.fire_state_manager.damage_fire(damage)
