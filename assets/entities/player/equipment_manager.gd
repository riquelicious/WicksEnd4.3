class_name EquipmentManger
extends Node

var player : PlayerA
var equipment_sway_amout : float = 0.0005
var equipment_node : Node3D
var default_equipment_hold_position : Vector3

func initialize(player_instance: PlayerA):
	player = player_instance
	equipment_node = player.get_node("Control/equipment-overlay/SubViewportContainer/SubViewport/viewmodel-camera/equipment_node")
	default_equipment_hold_position = equipment_node.position
	#turning_pads = player.get_node("on-screen-ui/turning-pads")
	#turning_panel_animation = player.get_node("on-screen-ui/turning-pads/turning_panel_animation")

func update_sway(delta):
	var mouse_input = lerp(Vector2.ZERO, Vector2.ZERO, 10 * delta)
	equipment_node.rotation.x = lerp(equipment_node.rotation.x, mouse_input.y * equipment_sway_amout, 10 * delta)
	equipment_node.rotation.y = lerp(equipment_node.rotation.y, mouse_input.x * equipment_sway_amout, 10 * delta)

func update_bob(vel : float, delta):
	if equipment_node:
		if vel > 0:
			var bob_amount : float = 0.01
			var bob_freq : float = 0.01
			equipment_node.position.z = lerp(equipment_node.position.z, default_equipment_hold_position.z + sin(Time.get_ticks_msec() * bob_freq) * bob_amount, 10 * delta)
			equipment_node.position.y = lerp(equipment_node.position.y, default_equipment_hold_position.y + sin(Time.get_ticks_msec() * bob_freq) * bob_amount, 10 * delta)
			player.audio_manager.calculate_foot_dir(equipment_node.position.y)
		else:
			equipment_node.position.z = lerp(equipment_node.position.z, default_equipment_hold_position.z, 10 * delta)
			equipment_node.position.y = lerp(equipment_node.position.y, default_equipment_hold_position.y, 10 * delta)
