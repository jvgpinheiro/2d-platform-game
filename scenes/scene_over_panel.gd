extends Panel

@onready var trophy = $Trophy
@onready var rating = $Rating
@onready var personal_best = $PersonalBest

func _on_game_manager_scene_finished(result):
	visible = true
	rating.display_rating(result)
	trophy.trophy_enter_animation()
	personal_best.update_personal_best(result)
