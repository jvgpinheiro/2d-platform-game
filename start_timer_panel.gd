extends Panel


@onready var countdown_label = $CountdownLabel
@onready var timer = $Timer
var countdown_seconds_remaining = 3
var counting_down = false


func _ready():
	if not visible or counting_down:
		return
	start_countdown()


func start_countdown():
	counting_down = true
	countdown_seconds_remaining = 3
	update_label()
	timer.start()


func stop_countdown():
	counting_down = false
	timer.stop()


func update_label():
	countdown_label.text = var_to_str(countdown_seconds_remaining)


func _on_game_manager_delayed_resume_started():
	visible = true
	if not countdown_label or not timer:
		return
	start_countdown()


func _on_game_manager_resumed():
	visible = false
	if not countdown_label or not timer:
		return
	stop_countdown()


func _on_timer_timeout():
	countdown_seconds_remaining -= 1
	update_label()
