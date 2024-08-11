class_name FireSystem
extends Node

@onready var active_checker: Area3D = $active_checker
@onready var fire_container: Node = $fire_container

var fires = []
var finished := false
var percentage_done : float = 0.0
var fire_count : int
func _ready() -> void:
	fire_count = fire_container.get_child_count()

func _process(delta: float) -> void:
	finished = fires.size() == 0
	percentage_done = (float(fires.size())/float(fire_count)) * 100.0

func fire_alive(body):
	fires.append(body)
	
func fire_killed(body):
	fires.erase(body)
