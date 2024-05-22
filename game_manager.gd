extends Node

signal on_max_points_changed(max_points: float)
signal on_points_changed(points: float)
signal on_total_time_elapsed_change(time_elapsed: float, formatted_time_elapsed: String)
signal on_scene_time_elapsed_change(time_elapsed: float, formatted_time_elapsed: String)
signal scene_finished(result: Dictionary)
signal game_finished(results: Array[Dictionary])
signal paused()
signal resumed()

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
	var stars_rating = get_scene_star_rating()
	var result = {
		"max_points": max_points,
		"points": points,
		"scene_time_elapsed": scene_time_elapsed,
		"accumlated_time_elapsed": total_time_elapsed,
		"stars_rating": stars_rating,
	}
	finished_scenes_results.push_back(result)
	#Scene finish delayed timer
	finished_scene_timer.start()
	finish_game()


func get_scene_star_rating():
	var safe_time = round(scene_time_elapsed)
	if safe_time <= 21:
		return 5
	if safe_time <= 27:
		return 4
	if safe_time <= 35:
		return 3
	if safe_time <= 48:
		return 2
	return 1


func finish_game():
	#Game finish delayed timer
	finished_game_timer.start()


func reset_game():
	isFinished = false
	update_scene_time_elapsed(0)
	reset_max_points()
	reset_points()


func _on_finished_scene_timer_timeout():
	var result = finished_scenes_results[finished_scenes_results.size() - 1]
	pause()
	scene_finished.emit(result)


func _on_finished_game_timer_timeout():
	isFinished = true
	pause()
	game_finished.emit(finished_scenes_results)
