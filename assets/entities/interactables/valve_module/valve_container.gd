class_name SprinklerSystem
extends Node

 
var valve_status_manager : ValveStatusManager = ValveStatusManager.new()
var sprinkler_status_manager : SprinklerStatusManager = SprinklerStatusManager.new()
var valves : Array[Node]
var sprinklers : Array[Node]
var valve_container : Node 
var sprinkler_container : Node
var markers_added := false
func _ready() -> void:
	valve_container = get_node("valve_container")
	sprinkler_container = get_node("sprinkler_container")
	valves = valve_container.get_children()
	sprinklers = sprinkler_container.get_children()
	#add_markers()

func _process(delta: float) -> void:
	var status = valve_status_manager.is_mission_finished(valves)
	sprinkler_status_manager.activate_sprinklers(status, sprinklers)

class ValveStatusManager:
	var finished : bool = false

	func is_mission_finished(valves : Array[Node]):
		if finished: return true
		var valve_finished : int = 0
		for valve in valves:
			if not "valve_manager" in valve:
				push_error("Invalid key valve_manager in node %s" % valve.name)
				continue
			valve_finished += int(valve.valve_manager.finished)
		if valve_finished == valves.size():
			finished = true
		return finished
class SprinklerStatusManager:
	var finished : bool = false

	func activate_sprinklers(status : bool, sprinklers : Array):
		if not status: return
		if finished: return
		for sprinkler in sprinklers:
			sprinkler.kill_fire()
		finished = true
func add_markers():
	if markers_added: return
	markers_added = true
	for valve in valves:
		valve.objective_marker.add_objective_marker()
		valve.objective_marker.show_marker = true
