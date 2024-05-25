extends Panel

@onready var trophy = $CenterControl/Trophy
@onready var rating = $CenterControl/Rating
@onready var personal_best = $TopLeftControl/PersonalBest

func _on_game_manager_scene_finished(result):
	rating.display_rating(result)
	trophy.trophy_enter_animation()
	personal_best.update_personal_best(result)
	visible = true
