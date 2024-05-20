extends Node

var points = 0
var time_elapsed = 0

func add_point():
	points += 1
	print(points)

func get_points():
	return points

func update_time_elapsed(time):
	time_elapsed = time

func get_time_elapsed():
	return time_elapsed

func get_formatted_time_elapsed():
	var time = round(time_elapsed)
	var seconds = int(time) % 60
	var minutes = int(floor(time / 60)) % 60
	var hours = int(floor(time / 24 / 60)) % 24
	var padded_seconds = "%02d" % seconds
	var padded_minutes = "%02d" % minutes
	var padded_hours = "%02d" % hours
	
	if not hours:
		return padded_minutes + ":" + padded_seconds
	return padded_hours + ":" + padded_minutes + ":" + padded_seconds
