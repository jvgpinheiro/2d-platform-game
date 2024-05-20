extends Label

@onready var game_manager = %GameManager

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = game_manager.get_formatted_scene_time_elapsed()
