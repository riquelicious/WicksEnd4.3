# class_name ResourceBar extends Control

var bar: TextureProgressBar
var bar_stat: Stat

func _init(bar_node: TextureProgressBar, stat: Stat):
	self.bar = bar_node
	bar.max_value = stat.max_amount
	bar.value = stat.max_amount

func _process(delta):
	bar.value = bar_stat.current_amount
