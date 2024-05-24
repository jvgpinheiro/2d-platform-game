extends Label

@onready var timer = $Timer
var is_active = false
var alpha = 1
var is_alpha_increasing = false


func _process(delta):
	if not is_active:
		return
	var alpha_step_multipier = 1 if is_alpha_increasing else -1
	var alpha_step = 1.5 * delta * alpha_step_multipier
	alpha += alpha_step
	alpha = clamp(alpha, 0, 1)
	modulate.a = alpha
	if (alpha == 0 || alpha == 1):
		is_alpha_increasing = !is_alpha_increasing
		activate_timer_loop()


func activate():
	is_active = true


func deactivate():
	is_active = false


func activate_timer_loop():
	deactivate()
	timer.wait_time = 0.5
	timer.start()


func _on_timer_timeout():
	activate()
