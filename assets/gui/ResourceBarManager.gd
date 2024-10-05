class_name ResourceBarManager extends Node

var gui: GUI
var HealthBar: ProgressBar
var LiquidBar: ProgressBar
var Health: Stat
var Liquid: Stat

func _ready():
	HealthBar = gui.get_node_or_null("UICanvas/ResourceBars/VBoxContainer/HealthBar")
	LiquidBar = gui.get_node_or_null("UICanvas/ResourceBars/VBoxContainer/LiquidBar")
	Health = gui.player.health_bar
	change_liquid(gui.player.nozzle_bar)

func _init(gui_instance: GUI) -> void:
	self.gui = gui_instance
	
func change_liquid(stat: Stat) -> void:
	Liquid = stat

func _process(delta):
	update_bars(HealthBar, Health)
	update_bars(LiquidBar, Liquid)

func update_bars(bar: ProgressBar, stat: Stat) -> void:
	if bar == null or stat == null: return
	bar.value = stat.current_amount