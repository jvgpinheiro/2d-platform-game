extends Node2D

@onready var sprite_2d =  $AnimatedSprite2D

var animation_name = 'idle'


func _process(delta):
	if animation_name and sprite_2d.frame == 7:
		animation_name = 'idle'
	sprite_2d.play(animation_name)


func _on_game_manager_scene_finished(result):
	animation_name = 'complete'
