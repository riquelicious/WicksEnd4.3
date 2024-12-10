class_name GameUI extends Control

var health_progress_bar: TextureProgressBar
var water_progress_bar: TextureProgressBar
var foam_progress_bar: TextureProgressBar
var counter_label: Label
var cdt_timer: Timer = Timer.new()
var count_down_timer = CountDownTimer

func _ready():
	health_progress_bar = get_node_or_null("Footer/Columns/MidContainer/HealthBar")
	water_progress_bar = get_node_or_null("Footer/Columns/LeftContainer/WaterBar")
	foam_progress_bar = get_node_or_null("Footer/Columns/LeftContainer/FoamBar")
	counter_label = get_node_or_null("Header/Column/MidContainer/TimerLabel")
	count_down_timer = CountDownTimer.new(counter_label, cdt_timer)
	add_child(cdt_timer)
	#debug!!
	#cdt_timer.wait_time = 1
	count_down_timer._ready()

class CountDownTimer:
	var counter_lbl
	var counter

	func _init(counter_label: Label, counter_timer: Timer):
		self.counter_lbl = counter_label
		self.counter = counter_timer

	func _ready():
		if counter.time_left > 0.0:
			counter.start()
		else:
			push_warning("CountDown not set Properly")

	func _process(delta):
		var time_left = convert_time(counter.time_left)
		self.counter_lbl.text = time_left

	func convert_time(time: float) -> String:
		if time and time > 0.0:
			var minutes = time / 60
			var seconds = fmod(time, 60)
			var milliseconds = fmod(time, 1) * 100
			var text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
			return text
		return "0:00:00"

class ResourceBar:

	var bar: TextureProgressBar
	var stat: Stat

	func _init(bar_instance: TextureProgressBar, stat_instance: Stat):
		self.bar = bar_instance
		self.stat = stat_instance

	func _ready():
		self.bar.max_value = self.stat.max_amount
		self.bar.value = self.stat.max_amount

	func _process(delta):
		self.bar.value = self.stat.current_amount

func _process(delta):
	count_down_timer._process(delta)
