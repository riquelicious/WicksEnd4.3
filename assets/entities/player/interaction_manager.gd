class_name InteractionManager
extends Node

var player : PlayerA
var straight_interaction_raycast : RayCast3D
var axe_damage : float
var anim : AnimationPlayer

func initialize(player_instance: PlayerA):
	player = player_instance
	straight_interaction_raycast = player.get_node("raycasts/InteractRay")
	axe_damage = Global.equipment_settings.calculate_stat(["axe","damage"])
	anim = player.get_node("AnimationPlayer")

func check_collision():
	var collider = straight_interaction_raycast.get_collider()
	if collider:
		if collider.is_in_group("breakable"):
			do_breakable(collider)
		elif collider.is_in_group("interactable"):
			do_interactables(collider)
		elif collider.is_in_group("pickup"):
			do_pickups(collider)
		elif collider.is_in_group("civilian"):
			do_civilian(collider)
	else:
		player.objective_markers.switch_crosshair("crosshair")
		if not anim.is_playing():
			change_equipment(0)

func do_breakable(collider):
	player.objective_markers.switch_crosshair("breakable")
	if Global.gesture_settings.gesture == GlobalControls.eqAxeSwing:
		change_equipment(1)
		if not anim.is_playing():
			anim.play("swing")
			await anim.animation_finished
			collider.do_damage(axe_damage)
			anim.queue("reset_axe")
			await anim.animation_finished

func do_interactables(collider):
	player.objective_markers.switch_crosshair("interaction")
	if Global.gesture_settings.gesture == GlobalControls.mvInteract:
		if "positioner" in collider:
			if player.is_interacting: return
			anim.play("hide_equipment")
			await anim.animation_finished
			collider.positioner.default_camera_position = player.default_cam_marker.global_position
			collider.positioner.is_interacting = true
			player.is_interacting = true
			collider.positioner.do_camera_positioned = true
			player.camera_manager.back_button_container.visible = true 
			player.gauges.visible = false
	elif player.camera_manager.reset_camera:
		if "positioner" in collider:
			if not player.is_interacting: return
			player.is_interacting = false
			player.camera_manager.reset_camera = false
			collider.positioner.do_camera_positioned = false
			player.camera_manager.back_button_container.visible = false
			player.gauges.visible = true
			anim.play_backwards("hide_equipment")
			await anim.animation_finished

func do_pickups(collider):
	player.objective_markers.switch_crosshair("interaction")
	if Global.gesture_settings.gesture == GlobalControls.mvInteract:
		if is_instance_valid(collider):
			collider.pickup_manager.pickup()
	
func do_civilian(collider):
	player.objective_markers.switch_crosshair("interaction")
	if Global.gesture_settings.gesture == GlobalControls.mvInteract:
		if is_instance_valid(collider):
			collider.pickup_manager.pickup()

func change_equipment(equipment: int):
	var equipments = player.equipment_manager.equipment_node.get_children()
	if equipments[equipment].visible == true:
		return
	else:
		anim.play("hide_equipment")
		await anim.animation_finished
		for eq in equipments:
			eq.visible = false
		equipments[equipment].visible = true
		anim.play_backwards("hide_equipment")
		await anim.animation_finished