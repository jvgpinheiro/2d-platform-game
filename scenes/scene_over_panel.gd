extends Panel


@onready var game_manager = %GameManager
@onready var trophy = $CenterControl/Trophy
@onready var rating = $CenterControl/Rating
@onready var personal_best = $TopLeftControl/PersonalBest

func _on_game_manager_scene_finished(result):
	rating.display_rating(result)
	trophy.trophy_enter_animation()
	personal_best.update_personal_best(result)
	visible = true


func _on_restart_button_pressed():
	game_manager.reset_game()


func _on_exit_button_pressed():
	game_manager.quit()
