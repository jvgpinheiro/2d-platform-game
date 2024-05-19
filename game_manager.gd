extends Node

var points = 0

func add_point():
	points += 1
	print(points)

func get_points():
	return points
