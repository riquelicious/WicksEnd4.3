extends CenterContainer

@onready var on_game_timer: Timer = $"on-game-timer"
@onready var on_game_timer_display: Label = $"on-game-timer-display"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time = format_timer(on_game_timer.time_left)
	on_game_timer_display.text = time

func update_timer():
	on_game_timer.start(Global.level_settings.level_timer_list[Global.level_settings.level_selection])

func format_timer(time : float):
	var minutes = time/60
	var seconds = fmod(time,60)
	var milliseconds = fmod(time,1) * 100
	var text = "%02d:%02d:%02d" % [minutes,seconds,milliseconds]
	return str(text)
