extends Area3D

var area_manager : DebrisAreaManager = DebrisAreaManager.new() 

func _ready():
	area_manager.initialize(self)
