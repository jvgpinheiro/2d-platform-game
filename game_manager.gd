extends Node

signal on_max_points_changed(max_points: float)
signal on_points_changed(points: float)
signal on_total_time_elapsed_change(time_elapsed: float, formatted_time_elapsed: String)
signal on_scene_time_elapsed_change(time_elapsed: float, formatted_time_elapsed: String)
signal scene_finished(result: Dictionary)
signal game_finished(results: Array[Dictionary])
signal paused()
signal resumed()
signal game_saved()
signal game_loaded(data: Dictionary)
signal personal_best_updated(data: Dictionary)

@onready var finished_scene_timer = $FinishedSceneTimer
@onready var finished_game_timer = $FinishedGameTimer
var points = 0
var max_points = 0
var total_time_elapsed = 0
var scene_time_elapsed = 0
var isFinished = false
var isPaused = false
var finished_scenes_results = []
var pausable_group_name = "pausable"
var personal_best = INF
var save_game_dir_path = 'user://saves/'
var save_game_path = save_game_dir_path + '/save_game.save'

func _ready():
	load_game()

func add_max_points():
	if isFinished:
		return
	max_points += 1
	on_max_points_changed.emit(max_points)

func reset_max_points():
	if isFinished:
		return
	max_points = 0
	on_max_points_changed.emit(max_points)

func get_max_points():
	return max_points

func add_point():
	if isFinished:
		return
	points += 1
	on_points_changed.emit(points)
	if points == max_points:
		finish_scene()

func reset_points():
	if isFinished:
		return
	points = 0
	on_points_changed.emit(points)

func get_points():
	return points

func update_total_time_elapsed(time):
	if isFinished:
		return
	total_time_elapsed = time
	on_total_time_elapsed_change.emit(
		get_total_time_elapsed(),
		get_formatted_total_time_elapsed()
	)

func get_total_time_elapsed():
	return total_time_elapsed

func get_formatted_total_time_elapsed():
	var time = round(total_time_elapsed)
	return format_time_elapsed(time)

func update_scene_time_elapsed(time):
	if isFinished:
		return
	scene_time_elapsed = time
	on_scene_time_elapsed_change.emit(
		get_scene_time_elapsed(),
		get_formatted_scene_time_elapsed()
	)

func get_scene_time_elapsed():
	return scene_time_elapsed

func get_formatted_scene_time_elapsed():
	var time = round(scene_time_elapsed)
	return format_time_elapsed(time)

func format_time_elapsed(time):
	var safe_time = round(time)
	var seconds = int(safe_time) % 60
	var minutes = int(floor(safe_time / 60)) % 60
	var hours = int(floor(safe_time / 24 / 60)) % 24
	var padded_seconds = "%02d" % seconds
	var padded_minutes = "%02d" % minutes
	var padded_hours = "%02d" % hours
	
	if not hours:
		return padded_minutes + ":" + padded_seconds
	return padded_hours + ":" + padded_minutes + ":" + padded_seconds


func pause():
	paused.emit()
	get_tree().call_group(pausable_group_name, "_on_game_manager_paused")


func resume():
	resumed.emit()
	get_tree().call_group(pausable_group_name, "_on_game_manager_resumed")


func finish_scene():
	if isFinished:
		return
	var accumlated_time_elapsed = total_time_elapsed
	var stars_rating = get_scene_star_rating(scene_time_elapsed)
	var is_new_personal_best = is_inf(personal_best) || scene_time_elapsed < personal_best
	if is_new_personal_best:
		personal_best = scene_time_elapsed
		personal_best_updated.emit()
		save_game()
	var result = {
		"max_points": max_points,
		"points": points,
		"scene_time_elapsed": scene_time_elapsed,
		"formatted_scene_time_elapsed": get_formatted_scene_time_elapsed(),
		"accumlated_time_elapsed": total_time_elapsed,
		"formatted_total_time_elapsed": get_formatted_total_time_elapsed(),
		"stars_rating": stars_rating,
		"is_new_personal_best": is_new_personal_best,
		"personal_best": personal_best,
		"formatted_personal_best": format_time_elapsed(personal_best),
		"personal_best_stars_rating": get_scene_star_rating(personal_best)
	}
	finished_scenes_results.push_back(result)
	#Scene finish delayed timer
	finished_scene_timer.start()
	finish_game()
	if is_new_personal_best:
		personal_best = scene_time_elapsed
		personal_best_updated.emit()
		save_game()


func get_scene_star_rating(time):
	var safe_time = round(time)
	if safe_time <= 20:
		return 5
	if safe_time <= 27:
		return 4
	if safe_time <= 38:
		return 3
	if safe_time <= 52:
		return 2
	return 1


func finish_game():
	isFinished = true
	#Game finish delayed timer
	finished_game_timer.start()


func reset_game():
	isFinished = false
	update_scene_time_elapsed(0)
	reset_max_points()
	reset_points()


func save_game():
	var save_data = {
		"personal_best": personal_best
	}
	if not DirAccess.dir_exists_absolute(save_game_dir_path):
		DirAccess.make_dir_absolute(save_game_dir_path)
	var save_game = FileAccess.open(save_game_path, FileAccess.WRITE)
	var json_save_data = JSON.stringify(save_data)
	save_game.store_line(json_save_data)
	save_game.close()
	game_saved.emit()


func load_game():
	if not FileAccess.file_exists(save_game_path):
		return
	var save_game = FileAccess.open(save_game_path, FileAccess.READ)
	var json_string = save_game.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		return
	var save_data = json.get_data()
	if save_data.personal_best:
		personal_best = save_data.personal_best
		personal_best_updated.emit()
	save_game.close()
	game_loaded.emit(save_data)


func _on_finished_scene_timer_timeout():
	var result = finished_scenes_results[finished_scenes_results.size() - 1]
	pause()
	scene_finished.emit(result)


func _on_finished_game_timer_timeout():
	pause()
	game_finished.emit(finished_scenes_results)
