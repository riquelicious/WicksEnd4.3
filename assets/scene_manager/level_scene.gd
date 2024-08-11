extends Control

@onready var traffic: AudioStreamPlayer = $TextureRect/traffic
@onready var truck: AudioStreamPlayer = $TextureRect/truck


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	truck.finished.connect(reset_truck)
	traffic.finished.connect(reset_traffic)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_traffic():
	traffic.stream_paused = false
	traffic.play()
	pass

func reset_truck():
	truck.stream_paused = false
	truck.play()
