@tool
class_name FireTextureManager
extends Node

var fire_shader := preload("res://assets/shaders/fire_mat.tres")
var fire : FireInstance 
var mat : Resource
var faces : Array 
var bottom : bool = false 
var mesh : MeshInstance3D
var previous_color : bool = false

var blue : bool = false :
	get: 
		return blue
	set(value):
		blue = value
		is_fire_blue(value)

func initialize(fire_instance : FireInstance): 
	fire = fire_instance
	faces = fire.get_node("faces").get_children()
	update_texture()

func update_texture():
	for face in faces:
		if not mat: 
			mat = fire_shader.duplicate()
			mat.set_shader_parameter("is_blue", false)
		face.material_override = mat

func update_position(is_bottom) -> void:
	bottom = is_bottom
	mat.set_shader_parameter("isBottom", bottom)

func is_fire_blue(is_blue : bool = false):
	if is_blue == null: 
		is_blue = false
	if previous_color == is_blue: return
	previous_color = is_blue
	update_texture()
	mat.set_shader_parameter("is_blue", is_blue)

func set_is_blue() -> void:
	if blue != fire.is_blue:
		blue = fire.is_blue
