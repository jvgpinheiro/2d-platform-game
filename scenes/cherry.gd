extends Area2D
@onready var sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer
@onready var game_manager = %GameManager

var is_destroying = false
var time_left_to_destroy = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.play('idle')
	add_to_group("pausable")
	game_manager.add_max_points()
	

func _process(delta):
	if game_manager.is_paused:
		sprite_2d.stop()
		return
	
	if (is_destroying):
		sprite_2d.play('collected')
	else:
		sprite_2d.play('idle')


func pause():
	game_manager.is_paused = true
	timer.paused = true


func resume():
	game_manager.is_paused = false
	timer.paused = false


func destroy():
	remove_from_group("pausable")
	queue_free()


func _on_body_entered(body):
	if not is_destroying and body.name == 'FrogMC':
		is_destroying = true
		game_manager.add_point()
		sprite_2d.play("collected")
		timer.start()


func _on_game_manager_paused():
	pause()


func _on_game_manager_resumed():
	resume()


func _on_timer_timeout():
	destroy()
