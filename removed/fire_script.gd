class_name Fire_Instance
extends Area3D

var on_bottom = false

@onready var fire_light := $fire_light
@onready var fire_audio := $fire_audio
@onready var ray = $fire_checker
@onready var timer = $update_timer
@onready var anim = $spawn_animation
@onready var collision_shape = $CollisionShape3D
@onready var fire_fx := $fire_fx
@onready var faces = [
	$faces/face1,
	$faces/face2,
	$faces/face3,
	$faces/face4
]

@export var is_alive = true


var target_volume : float = Global.audio_settings.default_fire_linear_volume
var current_volume : float = 0.0
var health = 100
var positions = {}
var mat
var time : float
var prev_health_amount := 100
var death_queued := false
var colliding_body = null
var damage_cooldown = Global.fire_settings.fire_damage_cooldown_speed

func _ready() -> void:
	fire_audio.finished.connect(_loop_audio)
	fire_audio.volume_db = linear_to_db(Global.audio_settings.default_fire_linear_volume)
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)
	_set_texture()
	_check_starting_state()
	_update_fire_default() 

func _check_starting_state() -> void:
	if not is_alive:
		for face in faces:
			face.visible = false
		health = 0

func _set_texture() -> void:
	mat = FilePaths.fire_shader.duplicate()
	for face in faces:
		face.material_override = mat

func _rng_fire() -> bool:
	var num = randi() % Global.fire_settings.fire_update_chances
	return ceil(num) == Global.fire_settings.fire_update_chances

func _update_fire_default() -> void:
	health = clamp(health + 5, 0 , 100)
	for direction in positions.keys():
		var value = positions[direction]
		ray.target_position = value
		timer.start(0.2)
		await timer.timeout
		var collider = ray.get_collider()
		if collider: 
			if collider.health <= 0: 
				var summon_fire = _rng_fire()
				if summon_fire:
					collider.kindle_fire()
					match direction:
						"TOP":
							if not on_bottom:
								toggle_on_bottom()
			else:		
				match direction:
					"TOP":
						if not on_bottom:
							toggle_on_bottom()

func _update_fire_on_death():
	for direction in positions.keys():
		var value = positions[direction]
		ray.target_position = value
		timer.start(0.2)
		await timer.timeout
		var collider = ray.get_collider()
		if collider: 
			if collider.health  > 0: 
				match direction:
					"BOTTOM":
						if collider.on_bottom:
							collider.toggle_on_bottom()

func kindle_fire() -> void:
	health = 100
	anim.play("fade")
	fire_fx.stream = FilePaths.fire_kindled_fx
	fire_fx.play()
	set_collision_layer_value(12,true)
	target_volume = Global.audio_settings.default_fire_linear_volume
	fire_light.visible = true

func extinguish_fire() -> void:
	anim.play_backwards("fade")
	fire_fx.stream = FilePaths.fire_extinguished_fx
	fire_fx.play()
	set_collision_layer_value(12,false)
	fire_light.visible = false
	target_volume = 0.0
	Global.level_settings.lvlPoints += 50

func toggle_on_bottom() -> void:
	on_bottom = !on_bottom
	mat.set_shader_parameter("is_on_bottom", on_bottom)

func _process(delta) -> void:
	if health <= 0: 
		if prev_health_amount != health:
			prev_health_amount = health
			extinguish_fire()
			_update_fire_on_death()
	else:	
		prev_health_amount = health
		time += delta
		if not time >= Global.fire_settings.fire_update_speed: return
		time = 0.0
		_update_fire_default()

func _physics_process(delta):
	_damage_colliding_body(delta)
	_volume_towards(delta)
	pass

func _body_entered(body):
	if body is PlayerA:
		colliding_body = body
func _body_exited(body):
	if body is PlayerA:
		colliding_body = null

func _damage_colliding_body(delta):
	if health <= 0: return
	if colliding_body:
		damage_cooldown += delta
		if not damage_cooldown >=GlobalVariables.fire_damage_cooldown_speed: return
		damage_cooldown = 0.0
		var new_health_value = colliding_body.health - GlobalVariables.fire_damage_value
		colliding_body.health = clamp(new_health_value, 0, 100)
		colliding_body.damage_animation_player.play("damage_animation")
		#print(colliding_body.health)
	else:
		damage_cooldown = GlobalVariables.fire_damage_cooldown_speed

func _loop_audio():
	fire_audio.stream_paused = false
	fire_audio.play()

func _volume_towards(delta):
	if target_volume == current_volume: return
	#print(current_volume)
	current_volume = lerp(current_volume, target_volume, 10 * delta)
	fire_audio.volume_db = linear_to_db(current_volume)

func damange_fire(amount):
	time = 0.0
	if on_bottom:
		ray.target_position = positions["TOP"]
		var collider = ray.get_collider()
		if collider:
			if collider.health > 0:
				collider.damange_fire(amount)
				return
	health -= amount
