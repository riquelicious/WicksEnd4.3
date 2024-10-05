class_name LiquidAbstract extends Node3D

var player: PlayerEntity
var raycast: RayCast3D
var camera: Camera3D
var liquid_particle: CPUParticles3D
var steam_particle: CPUParticles3D
var end_point: Marker3D
var liquidbar: Stat
var liquid_audio: AudioStreamPlayer3D
var damage: float

func _init(player_instance: PlayerEntity) -> void:
	self.player = player_instance
	
func _ready() -> void:
	self.camera = player.get_viewport().get_camera_3d()
	self.steam_particle = player.get_node_or_null("particles/SteamParticle")
	self.liquid_audio = player.get_node_or_null("sounds/LiquidAudio")
	self.end_point = camera.get_node("end_point")
	self.steam_particle.emitting = false

func update_status(delta: float) -> void:
	assert(liquid_particle != null)
	assert(steam_particle != null)
	assert(liquid_audio != null)
	assert(raycast != null)
	liquid_particle.emitting = is_emitting()
	#steam_particle.emitting = is_emitting()
	liquid_audio.stream_paused = !is_emitting()
	liquidbar.set_consume_loop(player.current_state == player.state.AIMING)
	if not player.current_state == player.state.AIMING or not liquidbar.current_amount > 0:
		while_not_emitting(delta)
	else:
		while_emitting(delta)


func while_emitting(delta: float) -> void:
	pass

func while_not_emitting(delta: float) -> void:
	pass
		
func is_emitting() -> bool:
	assert(liquidbar != null)
	return player.current_state == player.state.AIMING and liquidbar.current_amount > 0


func detect_collision() -> bool:
	var collider = raycast.get_collider()
	if collider:
		if collider is FireInstance:
			if collider.health > 0:
				extinguish_fire(collider)
				return true
	return false


func extinguish_fire(col: FireInstance) -> void:
	col.fire_state_manager.damage_fire(damage)

	
func update_particle_position() -> void:
	assert(end_point != null)
	liquid_particle.global_position = end_point.global_position
	liquid_particle.transform.basis.z = camera.transform.basis.z


func emmit_liquid() -> void:
	pass

func _physics_process(delta: float) -> void:
	update_status(delta)
