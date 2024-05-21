extends Area2D
@onready var sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer
@onready var game_manager = %GameManager

var isDestroying = false
var isPaused = false
var time_left_to_destroy = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("pausable")
	game_manager.add_max_points()
	

func _process(delta):
	if isPaused:
		sprite_2d.stop()
		return
	
	if (isDestroying):
		sprite_2d.play('collected')
	else:
		sprite_2d.play('idle')


func pause():
	isPaused = true
	timer.paused = true


func resume():
	isPaused = false
	timer.paused = false


func destroy():
	remove_from_group("pausable")
	queue_free()


func _on_body_entered(body):
	if not isDestroying and body.name == 'FrogMC':
		isDestroying = true
		game_manager.add_point()
		sprite_2d.play("collected")
		timer.start()


func _on_game_manager_paused():
	pause()


func _on_game_manager_resumed():
	resume()


func _on_timer_timeout():
	destroy()
