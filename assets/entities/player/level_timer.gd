extends CenterContainer

@onready var on_game_timer: Timer = $"on-game-timer"
@onready var on_game_timer_display: Label = $"on-game-timer-display"

func _ready() -> void:
	update_timer()

func _process(delta: float) -> void:
	var time = format_timer(on_game_timer.time_left)
	on_game_timer_display.text = time

func update_timer():
	on_game_timer.start(Global.level_settings.get_level_time())

func format_timer(time: float):
	var minutes = time / 60
	var seconds = fmod(time, 60)
	var milliseconds = fmod(time, 1) * 100
	var text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	return str(text)
