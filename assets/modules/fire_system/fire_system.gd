class_name FireSystem
extends Node

@onready var fire_container: Node = $fire_container
var fires = []
var finished := false
var percentage_done : float = 0.0
var children
var fire_index : int = 0

func _ready() -> void:
	children = fire_container.get_children()
	
#func _process(delta: float) -> void:
	#if finished: return
	#if fire_index <= children.size() - 1:
		#if children[fire_index].health > 0: return
		#fire_index += 1
	#else:
		#finished = true
