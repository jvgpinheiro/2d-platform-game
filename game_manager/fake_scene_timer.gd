extends Label

@onready var game_manager = %GameManager

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time_elapsed = game_manager.get_scene_time_elapsed()
	time_elapsed += delta
	game_manager.update_scene_time_elapsed(time_elapsed)
	text = game_manager.get_formatted_scene_time_elapsed()
