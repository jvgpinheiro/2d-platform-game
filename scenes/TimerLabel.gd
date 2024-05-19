extends Label

@onready var game_manager = %GameManager

var time_elapsed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	game_manager.update_time_elapsed(time_elapsed)
	text = game_manager.get_formatted_time_elapsed()
