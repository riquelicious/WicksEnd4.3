extends Control

@onready var objective_module : PackedScene = FilePaths.uiObjectiveMarker
@onready var sprite_container := $sprite_container
@onready var animation_player := $AnimationPlayer
@onready var player := $"../../.."
@onready var textures_gestures := [
	GlobalControls.mvInteract,
	GlobalControls.eqAxeSwing
]
var current_flags := {
	"sprite" : ""
} 
var previous_flags := {
	"sprite_visibility" : true
}

var disable_cursor : int

func _ready() -> void:
	_initiate_texture()
	sprite_container.position = get_viewport().get_visible_rect().size / 2 - (sprite_container.size / 2)
	_hide_sprites()
	switch_crosshair("crosshair")

	
func _process(_delta):
	disable_cursor = 0
	disable_cursor += int(player.is_aim_active)
	disable_cursor += int(player.is_interacting)
	if previous_flags["sprite_visibility"] == bool(disable_cursor): return
	if bool(disable_cursor):
		switch_crosshair("")
	else:
		switch_crosshair("crosshair")
	previous_flags["sprite_visibility"] = bool(disable_cursor)


func add_3d_marker(target : Node3D):
	var objective_instance = objective_module.instantiate()
	objective_instance.marker_target = target
	self.add_child(objective_instance)
	self.move_child(objective_instance, 0)
	return objective_instance.get_instance_id()

func _hide_sprites() -> void:
	for child in sprite_container.get_children():
		child.visible = false

func switch_crosshair(sprite_name: String):
	if previous_flags["sprite_visibility"]: return
	if current_flags["sprite"] == sprite_name: return
	current_flags["sprite"] = sprite_name
	animation_player.play("fade")
	await animation_player.animation_finished
	_hide_sprites()
	if not sprite_name == "":
		var sprite = sprite_container.find_child(sprite_name)
		sprite.visible = true
		animation_player.play_backwards("fade")

func _initiate_texture():
	var child_count := sprite_container.get_child_count()
	for i in range(1,child_count):
		var gesture_index = Global.gesture_settings.gesture_list.find(textures_gestures[i-1])
		var child = sprite_container.get_child(i)
		child.texture = FilePaths.cursor_images[gesture_index]
