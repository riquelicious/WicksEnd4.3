class_name FireTextureManager
extends Node

var fire : FireInstance
var mat : Resource
var faces : Array 
var bottom : bool = false 

func initialize(fire_instance : FireInstance): 
	fire = fire_instance
	faces = fire.get_node("faces").get_children()
	update_texture()

func update_texture():
	mat = FilePaths.fire_shader.duplicate()
	for face in faces:
		face.material_override = mat

func update_position(is_bottom) -> void:
	bottom = is_bottom
	mat.set_shader_parameter("is_on_bottom", bottom)
