extends Area3D

var area_manager : ComboAreaManager = ComboAreaManager.new()

func _ready():
	area_manager.initialize(self)
