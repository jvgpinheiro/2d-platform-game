extends Panel

@onready var rating = $Rating

func _on_game_manager_scene_finished(result):
	visible = true
	rating.display_rating(result)
