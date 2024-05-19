extends Area2D
@onready var sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer
@onready var game_manager = %GameManager

var isDestroying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.play('idle')


func _on_body_entered(body):
	if not isDestroying and body.name == 'Frog_MC':
		isDestroying = true
		game_manager.add_point()
		sprite_2d.play("collected")
		timer.start()


func _on_timer_timeout():
	queue_free()
