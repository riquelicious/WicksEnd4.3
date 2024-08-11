class_name SprinklerMain
extends Area3D

@onready var damage_delay : Timer = $"damage_delay"
@onready var sprinkler_audio : AudioStreamPlayer3D = $"sprinkler/sprinkler_audio"
@onready var particle_node : GPUParticles3D = $"sprinkler/GPUParticles3D"

var area_collision : AreaCollision = AreaCollision.new()
var fire_control : FireControl = FireControl.new()
var audio_control : AudioControl = AudioControl.new()
var particle_control : ParticleContol = ParticleContol.new()

func _ready() -> void:
	area_entered.connect(area_collision.append_fire_body.bind())
	area_exited.connect(area_collision.remove_fire_body.bind())
	damage_delay.timeout.connect(kill_fire)
	audio_control.audioplayer = sprinkler_audio
	sprinkler_audio.finished.connect(audio_control.loop_audio)
	particle_control.particle = particle_node
	particle_node.emitting = false
	

func kill_fire():
	if area_collision.flames.size() > 0:
		var flames = area_collision.flames
		fire_control.extinguish_fire(flames)
		damage_delay.start()
		audio_control.update_audio_status(true)
		particle_control.update_particles(true)
	else:
		damage_delay.stop()
		audio_control.update_audio_status(false)
		particle_control.update_particles(false)

class AreaCollision:
	var flames : Array = []

	func append_fire_body(body):
		if not body in flames:
			flames.append(body)

	func remove_fire_body(body):
		if not body in flames:
			flames.erase(body)

class FireControl:
	func extinguish_fire(flames):
		for fire in flames:
			fire.fire_state_manager.damage_fire(10)
			
	
class AudioControl:
	var audioplayer : AudioStreamPlayer3D
	var playing : bool

	func update_audio_status(status : bool):
		if not audioplayer: return
		if status:
			if not audioplayer.playing:
				audioplayer.play()
		else:
			audioplayer.stop()
		playing = status

	func loop_audio():
		if not playing: return
		audioplayer.stream_paused = false
		audioplayer.play()

class ParticleContol:
	var particle : GPUParticles3D

	func update_particles(status : bool):
		particle.emitting = status
