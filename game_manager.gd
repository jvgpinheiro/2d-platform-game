extends Node

signal on_max_points_changed(max_points)
signal on_points_changed(points)

var points = 0
var max_points = 0
var total_time_elapsed = 0
var scene_time_elapsed = 0

func add_max_points():
	max_points += 1
	on_max_points_changed.emit(max_points)

func reset_max_points():
	max_points = 0
	on_max_points_changed.emit(max_points)

func get_max_points():
	return max_points

func add_point():
	points += 1
	on_points_changed.emit(points)

func reset_points():
	points = 0
	on_points_changed.emit(points)

func get_points():
	return points

func update_total_time_elapsed(time):
	total_time_elapsed = time

func get_total_time_elapsed():
	return total_time_elapsed

func get_formatted_total_time_elapsed():
	var time = round(total_time_elapsed)
	return format_time_elapsed(time)

func update_scene_time_elapsed(time):
	scene_time_elapsed = time

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
	
func on_scene_reset():
	update_scene_time_elapsed(0)
	reset_max_points()
	reset_points()
