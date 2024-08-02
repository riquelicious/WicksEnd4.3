extends CanvasLayer

@onready var cursor_sprite := $Control/Sprite2D
@onready var gesture_timer := $gesture_timer

@export var interpolation_sensitivity = 10

var handedness : String
var mouse_mode = true;

const GESTURE_CD := 0.2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN);

func set_pseudo_mouse_mode(pseudo_mouse_mode : bool) -> void:
	mouse_mode = pseudo_mouse_mode;

func _process(delta):
	if mouse_mode:
		var _current_pos : Vector2 = get_viewport().get_mouse_position()
		cursor_sprite.position = cursor_sprite.position.lerp(_current_pos, delta * interpolation_sensitivity);
	if gesture_timer.time_left != 0: return
	if MousePositioning.is_hand_on_screen:
		gesture_timer.start(GESTURE_CD)
		var gesture_index = Global.gesture_settings.gesture_list.find(Global.gesture_settings.gesture)
		if gesture_index == 0: return
		cursor_sprite.texture = FilePaths.cursor_images[gesture_index]
		cursor_sprite.flip_h = handedness.to_lower() == 'left'
	else:
		cursor_sprite.texture = FilePaths.cursor_images[0]
	
