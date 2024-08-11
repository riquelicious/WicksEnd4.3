class_name InteractionManager
extends Node

var player : PlayerA 
var straight_interaction_raycast : RayCast3D
var axe_damage : float
var anim : AnimationPlayer
var is_civilian_carried : bool = false
var drop_flag : bool = false
var pick_flag : bool = false
var civilian_id 
var previous_gesture : String = ""
var gauges : Node2D
var objective_markers : Control
var equipment_manager : EquipmentManger
var iframes_duration : float 
var iframes_timer : Timer
var defense : float

func initialize(player_instance: PlayerA):
	player = player_instance
	straight_interaction_raycast = player.get_node("raycasts/InteractRay")
	anim = player.get_node("AnimationPlayer")
	gauges = player.get_node("Control/on-screen-ui/ui/gauges/SubViewport/gauges")
	objective_markers = player.get_node("Control/equipment-overlay/ObjectMarkers")
	equipment_manager = player.equipment_manager
	iframes_timer = player.get_node("timers/iframe_delay")
	iframes_timer.one_shot = true
	iframes_duration = Global.fire_settings.fire_damage_cooldown_speed
	axe_damage = Global.equipment_settings.calculate_stat(["axe","damage"])
	defense = Global.equipment_settings.calculate_stat(["gear","defense"])

func check_collision():
	if player.is_aim_active: return
	var collider = straight_interaction_raycast.get_collider()
	if is_civilian_carried: 
		if collider: 
			if not collider.is_in_group("civilian"):
				return
		do_drop_civilian()
		pick_flag = false
		return
	drop_flag = false
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
		objective_markers.switch_crosshair("crosshair")
		# if not anim.is_playing():
		# 	change_equipment(0)

func do_breakable(collider):
	if not player.inventory_manager.current_index == 1: return
	objective_markers.switch_crosshair("breakable")
	if Global.gesture_settings.gesture == GlobalControls.eqAxeSwing:
		equipment_manager.change_equipment(1)
		if not anim.is_playing():
			anim.play("swing")
			await anim.animation_finished
			collider.do_damage(axe_damage)
			anim.queue("reset_axe")
			await anim.animation_finished

func do_interactables(collider):
	objective_markers.switch_crosshair("interaction")
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
			gauges.visible = false
	elif player.camera_manager.reset_camera:
		if "positioner" in collider:
			if not player.is_interacting: return
			player.is_interacting = false
			player.camera_manager.reset_camera = false
			collider.positioner.do_camera_positioned = false
			player.camera_manager.back_button_container.visible = false
			gauges.visible = true
			anim.play_backwards("hide_equipment")
			await anim.animation_finished

func do_pickups(collider):
	objective_markers.switch_crosshair("interaction")
	if Global.gesture_settings.gesture == GlobalControls.mvInteract:
		collider.pickup_manager.pickup()
	
func do_civilian(collider):
	objective_markers.switch_crosshair("interaction")
	if Global.gesture_settings.gesture == GlobalControls.mvInteract:
		if not pick_flag: return
		is_civilian_carried = true
		collider.civilain_manager.pickup()
		civilian_id = collider.get_instance_id()
		objective_markers.switch_crosshair("crosshair")
		await equipment_manager.change_equipment(3 ,true)
	else:
		pick_flag = true

func do_drop_civilian():
	if Global.gesture_settings.gesture == GlobalControls.mvInteract:
		if not drop_flag: return
		await equipment_manager.change_equipment(0 ,true)
		var front = -player.transform.basis.z.normalized()
		var pos = player.global_transform.origin + front * 1
		var civ = instance_from_id(civilian_id)
		civ.civilain_manager.drop(pos)
		is_civilian_carried = false
	else:
		drop_flag = true

func damage_player(amount):
	if iframes_timer.time_left == 0:
		var remaining_health = player.health - (amount - ((amount * 0.01) * (defense)))
		prints(remaining_health, amount, ((amount * 0.01) * (defense)), (amount - ((amount * 0.01) * (defense))))
		player.health = clamp(remaining_health, 0.0, 100.0)
		player.damage_animation_player.play("damage_animation")
		iframes_timer.start(iframes_duration)
