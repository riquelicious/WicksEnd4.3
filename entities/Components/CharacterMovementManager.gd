class_name CharacterMovementManager extends CharacterBody3D

var player: CharacterBody3D
var mvHorizontalRotation: float
var viewport: Viewport
var viewport_size: Vector2
var turning_sensitivity: float = 0.9

func _init(player_instance: CharacterBody3D) -> void:
	self.player = player_instance

func _ready():
	viewport = player.get_viewport()
	viewport_size = viewport.get_visible_rect().size

func _physics_process(delta: float) -> void:
	update_movement(delta)

func update_movement(delta):
	if player.is_occupied(): return
	mvHorizontalRotation = detect_mouse_position()
	var direction = Vector3.ZERO.normalized()
	if Global.gesture_settings.is_gesture_matching(GlobalControls.walk):
		player.rotate_y(deg_to_rad(mvHorizontalRotation * delta))
		# TODO _turningpad_fade()
		if mvHorizontalRotation != 0:
			direction = (player.transform.basis * Vector3.ZERO).normalized()
		else:
			direction = (player.transform.basis * Vector3(0, 0, -1)).normalized()
	if not player.is_on_floor():
		player.velocity.y -= player.gravity * delta
	if direction:
		player.velocity.x = direction.x * Global.gameplay_settings.mvWalkingSpeed
		player.velocity.z = direction.z * Global.gameplay_settings.mvWalkingSpeed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, Global.gameplay_settings.mvWalkingSpeed)
		player.velocity.z = move_toward(player.velocity.z, 0, Global.gameplay_settings.mvWalkingSpeed)
	player.move_and_slide()

func detect_mouse_position():
	var pos = viewport.get_mouse_position()
	var dir = (pos - viewport_size / 2).normalized() * -1 # * inverted
	var dist = pos.distance_to(viewport_size / 2) * turning_sensitivity
	var new_dist = clamp(dist - (viewport_size.x / 6), 0, viewport_size.x)
	var final_displacement = new_dist * dir.x
	return final_displacement
