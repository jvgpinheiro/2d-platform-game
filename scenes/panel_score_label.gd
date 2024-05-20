extends Label

var max_points = 0
var points = 0

func _ready():
	update_score_text()

func _on_game_manager_on_max_points_changed(updated_max_points):
	max_points = updated_max_points
	update_score_text()


func _on_game_manager_on_points_changed(updated_points):
	points = updated_points
	update_score_text()

func update_score_text():
	text = var_to_str(points) + "/" + var_to_str(max_points)
