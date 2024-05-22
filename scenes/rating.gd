extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var label = $Label

const rating_img_path_dictionary = {
	1: "res://One Star.png",
	2: "res://Two Stars.png",
	3: "res://Three Stars.png",
	4: "res://Four Stars.png",
	5: "res://Five Stars.png",
}


func display_rating(scene_result):
	var path = rating_img_path_dictionary[scene_result.stars_rating]
	sprite_2d.texture = load(path)
	label.text = scene_result.formatted_scene_time_elapsed
