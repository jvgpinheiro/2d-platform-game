extends Node2D


@onready var time_label = $TimeLabel
@onready var sprite_2d = $Sprite2D


const rating_img_path_dictionary = {
	1: "res://One Star.png",
	2: "res://Two Stars.png",
	3: "res://Three Stars.png",
	4: "res://Four Stars.png",
	5: "res://Five Stars.png",
}


func update_personal_best(scene_result):
	var path = rating_img_path_dictionary[scene_result.personal_best_stars_rating]
	sprite_2d.texture = load(path)
	time_label.text = scene_result.formatted_personal_best
