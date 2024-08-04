class_name GameStateSettings
extends Node

var parent : Node
var player_position = Vector3()
var game_variables = {}
var current_scene_path = ""


func initialize(parent_instance : Node):
	parent = parent_instance