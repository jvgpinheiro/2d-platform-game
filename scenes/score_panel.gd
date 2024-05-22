extends Panel

signal max_points_change(max_points)
signal points_change(points)
signal scene_time_elapsed_change(time_elapsed, formatted_time_elapsed)
signal total_time_elapsed_change(time_elapsed, formatted_time_elapsed)

func _on_game_manager_on_max_points_changed(max_points):
	max_points_change.emit(max_points)


func _on_game_manager_on_points_changed(points):
	points_change.emit(points)


func _on_game_manager_on_total_time_elapsed_change(time_elapsed, formatted_time_elapsed):
	total_time_elapsed_change.emit(time_elapsed, formatted_time_elapsed)


func _on_game_manager_on_scene_time_elapsed_change(time_elapsed, formatted_time_elapsed):
	scene_time_elapsed_change.emit(time_elapsed, formatted_time_elapsed)


func _on_game_manager_scene_finished(result):
	visible = false
