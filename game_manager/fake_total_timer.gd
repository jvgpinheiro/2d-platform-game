extends Label

@onready var game_manager = %GameManager

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time_elapsed = game_manager.get_total_time_elapsed()
	time_elapsed += delta
	game_manager.update_total_time_elapsed(time_elapsed)
	text = game_manager.get_formatted_total_time_elapsed()
