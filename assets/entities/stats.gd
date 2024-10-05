extends RefCounted
class_name Stat

var max_amount: float
var current_amount: float
var regen_speed: float
var is_regenerating: bool = true
var consume_speed: float = 0.0
var is_consuming: bool = false

func _init(max_amount_init: float, regen_speed_init: float) -> void:
	self.max_amount = max_amount_init
	self.regen_speed = regen_speed_init
	self.current_amount = max_amount_init

func regenerate(delta: float) -> void:
	if is_consuming: return
	if is_regenerating:
		current_amount = min(current_amount + regen_speed * delta, max_amount)

func regeneration_timer():
	pass


func consume(amount: float) -> bool:
	if current_amount >= amount:
		current_amount -= amount
		return true
	return false

func reset() -> void:
	current_amount = max_amount

func set_regeneration(enabled: bool) -> void:
	is_regenerating = enabled

func set_consume_loop(enabled: bool) -> void:
	is_consuming = enabled

func consume_loop(delta: float) -> void:
	if is_consuming:
		current_amount = max(current_amount - consume_speed * delta, 0)