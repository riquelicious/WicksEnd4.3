class_name EquipmentManger
extends Node

var player: PlayerEntity
var equipment_sway_amout: float = 0.0005
var equipment_node: Node3D
var equipment_nodes
var default_equipment_hold_position: Vector3
var anim: AnimationPlayer
var gauge


func _init(player_instance: PlayerEntity) -> void:
	self.player = player_instance


func _ready() -> void:
	equipment_node = player.get_node_or_null("PlayerUI/EquipmentOverlay/SubViewport/viewmodel-camera/equipment_node")
	equipment_nodes = equipment_node.get_children()
	# gauge = player.get_node_or_null("Control/on-screen-ui/ui/gauges/SubViewport/gauges")
	anim = player.get_node_or_null("AnimationPlayer")
	default_equipment_hold_position = equipment_node.position
	change_equipment(0)

func update_sway(delta):
	var mouse_input = lerp(Vector2.ZERO, Vector2.ZERO, 10 * delta)
	equipment_node.rotation.x = lerp(equipment_node.rotation.x, mouse_input.y * equipment_sway_amout, 10 * delta)
	equipment_node.rotation.y = lerp(equipment_node.rotation.y, mouse_input.x * equipment_sway_amout, 10 * delta)

func update_bob(vel: float, delta):
	if equipment_node:
		if vel > 0:
			var bob_amount: float = 0.01
			var bob_freq: float = 0.01
			equipment_node.position.z = lerp(equipment_node.position.z, default_equipment_hold_position.z + sin(Time.get_ticks_msec() * bob_freq) * bob_amount, 10 * delta)
			equipment_node.position.y = lerp(equipment_node.position.y, default_equipment_hold_position.y + sin(Time.get_ticks_msec() * bob_freq) * bob_amount, 10 * delta)
			player.audio_manager.calculate_foot_dir(equipment_node.position.y)
		else:
			equipment_node.position.z = lerp(equipment_node.position.z, default_equipment_hold_position.z, 10 * delta)
			equipment_node.position.y = lerp(equipment_node.position.y, default_equipment_hold_position.y, 10 * delta)

func change_equipment(equipment_index: int, slowed: bool = false, ):
	if equipment_nodes[equipment_index].visible == true:
		return
	else:
		#TODO change animation or add
		if slowed:
			anim.speed_scale = 0.5
		anim.play("hide_equipment")
		await anim.animation_finished
		for eq in equipment_nodes:
			eq.visible = false
		equipment_nodes[equipment_index].visible = true
		anim.play_backwards("hide_equipment")
		await anim.animation_finished
		if slowed:
			anim.speed_scale = 1.0
	gauge.current_eq = equipment_index # ? changes the gauge dependent on the equipment

func _process(delta):
	update_sway(delta)
	update_bob(player.velocity.y, delta)
