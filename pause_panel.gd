extends Panel


@onready var game_manager = %GameManager


func _on_game_manager_paused():
	if game_manager.is_finished:
		return
	visible = true


func _on_game_manager_resumed():
	visible = false


func _on_resume_button_pressed():
	game_manager.resume()


func _on_restart_button_pressed():
	game_manager.reset_game()


func _on_exit_button_pressed():
	game_manager.quit()
