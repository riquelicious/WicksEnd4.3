class_name EquipmentViewport extends SubViewportContainer

var animation_player: AnimationPlayer
var player: PlayerCharacter


var current_equipment: Equip = Equip.NOZZLE
var water_particles: CPUParticles3D
var equipment = []

# * Composition
var equipmentAnimation: EquipmentAnimation = EquipmentAnimation.new(self)
var nozzle: Aim = Aim.new(self, Equip.NOZZLE, "aim_nozzle")
var extinguisher: Aim = Aim.new(self, Equip.EXTINGUISHER, "aim_extinguisher")

enum Equip {
	NOZZLE,
	AXE,
	EXTINGUISHER,
	CIVILIAN
}

func _ready() -> void:
	var eq = get_node_or_null("SubViewport/ViewModelCamera/Equipment").get_children()
	for e in eq:
		if e is Node3D:
			equipment.append(e)
	animation_player = get_node_or_null("SubViewport/ViewModelCamera/AnimationPlayer")
	if get_parent() is PlayerCharacter:
		player = get_parent()
	water_particles = equipment[Equip.NOZZLE].get_node("water_particles")
	water_particles.emitting = false
	equipmentAnimation._ready()

	await switch_equipment(Equip.NOZZLE)

func switch_equipment(eq: Equip) -> int:
	if eq == current_equipment or is_aiming():
		return 0
	animation_player.play("hide_equipment")
	await animation_player.animation_finished
	equipment[current_equipment].visible = false
	current_equipment = eq
	equipment[current_equipment].visible = true
	animation_player.play_backwards("hide_equipment")
	await animation_player.animation_finished
	return 1

func _process(delta):
	equipmentAnimation._process(delta)


func is_aiming():
	return player.current_state == player.PlayerState.AIMING

class EquipmentAnimation:

	var equipmentViewport: EquipmentViewport
	var EquipmentHolder: Node3D
	var player: PlayerCharacter

	var sway_amount: float = 0.0005


	var default_equipment_holder_position: Vector3

	func _init(equipment_viewport_instance: EquipmentViewport):
		self.equipmentViewport = equipment_viewport_instance

	func _ready():
		if equipmentViewport.get_parent() is PlayerCharacter:
			player = equipmentViewport.get_parent()
		EquipmentHolder = equipmentViewport.get_node_or_null("SubViewport/ViewModelCamera/Equipment")
		default_equipment_holder_position = EquipmentHolder.position

	func update_sway(delta):
		if not player: return
		var mouse_input = lerp(Vector2.ZERO, Vector2.ZERO, 10 * delta)
		EquipmentHolder.rotation.x = lerp(EquipmentHolder.rotation.x, mouse_input.y * sway_amount, 10 * delta)
		EquipmentHolder.rotation.y = lerp(EquipmentHolder.rotation.y, mouse_input.x * sway_amount, 10 * delta)

	func update_bob(velocity: Vector3, delta: float):
		if EquipmentHolder:
			if not velocity.is_equal_approx(Vector3.ZERO):
				var bob_amount: float = 0.01
				var bob_frequency: float = 0.01
				EquipmentHolder.position.z = lerp(EquipmentHolder.position.z, default_equipment_holder_position.z + sin(Time.get_ticks_msec() * bob_frequency) * bob_amount, 10 * delta)
				EquipmentHolder.position.y = lerp(EquipmentHolder.position.y, default_equipment_holder_position.y + sin(Time.get_ticks_msec() * bob_frequency) * bob_amount, 10 * delta)
			else:
				EquipmentHolder.position.z = lerp(EquipmentHolder.position.z, default_equipment_holder_position.z, 10 * delta)
				EquipmentHolder.position.y = lerp(EquipmentHolder.position.y, default_equipment_holder_position.y, 10 * delta)

	func _process(delta):
		update_sway(delta)
		if player:
			print(player.velocity)
			update_bob(player.velocity, delta)

class Aim:
	var parent: EquipmentViewport
	var equipment: int
	var animation: String
	var player: PlayerCharacter

	func _init(parent_instance: EquipmentViewport, equipment_index: int, animation_name: String):
		self.parent = parent_instance
		self.equipment = equipment_index
		self.animation = animation_name

	func _ready():
		if parent.get_parent() is PlayerCharacter:
			player = parent.get_parent()

	func is_current_equipment() -> bool:
		return parent.current_equipment == equipment

	func aim():
		if is_current_equipment() and not parent.is_aiming():
			parent.animation_player.play(animation)
			await parent.animation_player.animation_finished
			# parent.is_aiming() = true
			return true
		elif not is_current_equipment() and not parent.is_aiming():
			push_error("aiming on wrong equipment")
		else:
			push_error("aiming when not aimed")
		return false

	func stop_aim():
		if is_current_equipment() and parent.is_aiming():
			parent.animation_player.play_backwards(animation)
			await parent.animation_player.animation_finished
			# parent.is_aiming = false
			return true
		elif not is_current_equipment() and parent.is_aiming():
			push_error("stopping aim on wrong equipment")
		else:
			push_error("stopping aim when not aiming")
		return false
